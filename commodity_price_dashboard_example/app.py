import hvplot.pandas
import pandas as pd
import panel as pn
from bokeh.plotting import figure
from bokeh.models import ColumnDataSource
from bokeh.models.tools import HoverTool
# import panel as printpn.extension('tabulator')
pn.extension('tabulator')

data_url = 'https://drive.google.com/uc?id=1oybf4AyO1srI4KxiR4QK_7Z6AgzsbadD'

df = pd.read_excel(
    data_url,
    sheet_name=6,
    usecols=['End_Date', 'Import_Quantity', 'Monthly_Imports_Price_Average', 'Retail_Price_Average_MT','Country', 'City'],
    skiprows=0,
    parse_dates=['End_Date'])

df = df.rename(columns={'End_Date': 'Date', 'Monthly_Imports_Price_Average': 'Import_Price', 'Retail_Price_Average_MT': 'Retail_Price'})
df['Year'] = df['Date'].dt.year

# Normalize the Import_Quantity and Import_Price columns
df['Import_Quantity_N'] = (df['Import_Quantity'] - df['Import_Quantity'].min()) / (df['Import_Quantity'].max() - df['Import_Quantity'].min())
df['Import_Price_N'] = (df['Import_Price'] - df['Import_Price'].min()) / (df['Import_Price'].max() - df['Import_Price'].min())
df['Retail_Price_N'] = (df['Retail_Price'] - df['Retail_Price'].min()) / (df['Retail_Price'].max() - df['Retail_Price'].min())

# idf = df.interactive()

# Define the widgets
country_selection = pn.widgets.Select(name='Country', options=df['Country'].unique().tolist())
city_selection = pn.widgets.Select(name='City', options=df['City'].unique().tolist())

date_range_picker = pn.widgets.DateRangeSlider(name='Date Range', start=df['Date'].min(), end=df['Date'].max(),
                                      value=(df['Date'].min(), df['Date'].max()))

# Create the line chart for price
def create_price_line_chart(df, country, city, start_date, end_date):
    filtered_data = df[(df['Country'] == country) & (df['City'] == city) & (df['Date'] >= start_date) & (df['Date'] <= end_date)]
    line_chart = filtered_data.hvplot.line(x='Date', y='Import_Price_N', title=f'Import Prices Per Metric Tonne for {city}',
                                          ) #height=300, width=500
    return line_chart

# Create the table showing the values plotted on the price line chart
def create_price_table(df, country, city, start_date, end_date):
    filtered_data = df[(df['Country'] == country) & (df['City'] == city) & (df['Date'] >= start_date) & (df['Date'] <= end_date)]
    table = pn.widgets.DataFrame(filtered_data[['Date', 'Country', 'City', 'Import_Price', 'Retail_Price', 'Import_Quantity']].head(5)) #, height=300, width=500
    return table

# Create the line chart for price and import quantity
def create_price_quantity_line_chart(df, country, city, start_date, end_date):
    filtered_data = df[(df['Country'] == country) & (df['City'] == city) & (df['Date'] >= start_date) & (df['Date'] <= end_date)]
    line_chart = filtered_data.hvplot.line(x='Date', y=['Import_Price_N', 'Import_Quantity_N', 'Retail_Price_N'], ylabel='Import_Price and Import Quantity',
                                           title=f'Import_Price and Import Quantity for {city}', #, height=300, width=500
                                           legend='top_left',
                                           height=400, width=700)
    return line_chart

# Create the scatter map for price and import quantity
def create_price_quantity_scatter_map(df, country, city, start_date, end_date):
    filtered_data = df[(df['Country'] == country) & (df['City'] == city) & (df['Date'] >= start_date) & (df['Date'] <= end_date)]
    scatter_map = filtered_data.hvplot.points(x='Date', y='Import_Price_N', c='Import_Price_N', colormap='viridis', size='Import_Quantity_N', scale=30,
                                              clim=(df['Import_Price_N'].min(), df['Import_Price_N'].max()),
                                              title=f'Maize Import Prices Vs Import Quantity for {city}',
                                              xlabel='Date', ylabel='Import_Price_N', tools=['hover'], height=400, width=700) #height=300, width=500,
    
    # scatter_map.opts(tools=[HoverTool(tooltips=[('Import_Price_N', '@y'), ('Import_Quantity_N', '@c')])])
    return scatter_map

# Create the interactive Panel dashboard
@pn.depends(country_selection.param.value, city_selection.param.value, date_range_picker.param.value) #date_range_picker.param.value
def update_dashboard(country, city, date_range):
    start_date, end_date = date_range
    line_chart_price = create_price_line_chart(df, country, city, start_date, end_date)
    table_price = create_price_table(df, country, city, start_date, end_date)
    line_chart_price_quantity = create_price_quantity_line_chart(df, country, city, start_date, end_date)
    # line_chart.object = create_price_quantity_line_chart(df, country, city, start_date, end_date)
    scatter_map_price_quantity = create_price_quantity_scatter_map(df, country, city, start_date, end_date)
    
    return pn.Column(
        pn.Row(line_chart_price, table_price),
        # pn.Row(table_price),
        pn.Row(line_chart_price_quantity, scatter_map_price_quantity),
    )

dashboard = pn.template.FastListTemplate(
    title='Maize Import Prices/MT(USD) and Import Quantity(Tonne) Dashboard',
    sidebar=[
        # pn.pane.Markdown("### Maize Import Prices Vs Import Quantity"),
        pn.pane.Markdown("Select Country and City"),
        country_selection,
        city_selection,
        pn.pane.Markdown("Select Date Range"),
        pn.Row(date_range_picker),
        # date_range_picker
    ],
    main=update_dashboard,
    accent_base_color="#88d8b0",
    header_background="#88d8b0",
)

# # # Show the dashboard
dashboard.servable()
