# Import Relevant Libraries
import pandas as pd
import panel as pn
import plotly.express as px
from bokeh.plotting import figure
from bokeh.models import ColumnDataSource
from bokeh.models.tools import HoverTool
from geopy.geocoders import Nominatim
# import panel as printpn.extension('tabulator')
pn.extension('tabulator')
pn.extension('plotly')
import geopandas as gpd
import matplotlib.pyplot as plt
import cartopy.crs as ccrs

import hvplot.pandas

data_url = 'https://drive.google.com/uc?id=1_EBV3DpW7_Sz222Xrt8fU5cKKcXCtgDb'
# https://docs.google.com/spreadsheets/d/1_EBV3DpW7_Sz222Xrt8fU5cKKcXCtgDb/edit?usp=drive_link
df = pd.read_excel(data_url)

# Create widgets for country, city selection, and calendar
country_selection = pn.widgets.Select(name='Country', options=df['Country'].unique().tolist())
city_selection = pn.widgets.Select(name='City', options=df['City'].unique().tolist())
calendar = pn.widgets.DateRangeSlider(name='Date Range', start=df['Date'].min(), end=df['Date'].max(),
                                      value=(df['Date'].min(), df['Date'].max()))
# # Create choropleth map using Plotly
# def choropleth_map(df, country, city, start_date, end_date):
#     filtered_data = df[(df['Country'] == country) & (df['City'] == city) & (df['Date'] >= start_date) & (df['Date'] <= end_date)]
#     # Get the center coordinates for the specified city
#     center_lat = filtered_data["Latitude"].mean()
#     center_lon = filtered_data["Longitude"].mean()
#     fig = px.scatter_mapbox(
#     # df, lat="Latitude", lon="Longitude",
#     filtered_data, lat="Latitude", lon="Longitude",
#     text="City",
#     # projection='orthographic',
#     hover_name="City", hover_data=["Country", "Price", "Date"],
#     mapbox_style="carto-positron", zoom=2, #open-street-map
#     center={"lat": center_lat, "lon": center_lon},
#     height=500
#     )

#     fig.update_layout(
#     # mapbox_style="open-street-map",
#     mapbox_layers=[
#         {
#             "below": 'traces',
#             "sourcetype": "raster",
#             "sourceattribution": "United States Geological Survey",
#             "source": [
#                 "https://basemap.nationalmap.gov/arcgis/rest/services/USGSImageryOnly/MapServer/tile/{z}/{y}/{x}",
#             ]
#         }
#       ])
#     # /fig.update_layout(margin={"r":1,"t":1,"l":1,"b":1})

#     # # Show country boundaries using built-in geometries
#     # # fig.update_geos(showcoastlines=True, coastlinecolor="Black", showland=True, landcolor="LightGreen")
#     # fig.update_geos(
#     #     showcountries=True,
#     #     countrycolor="black",  # Color of country boundaries
#     #     showland=True,
#     #     # landcolor="lightgray",  # Color of land areas
#     #     # landcolor="LightGreen",
#     #     showocean=True,
#     #     oceancolor="navy",
#     #     showcoastlines=True,
#     #     coastlinecolor="gray",
#     #     showrivers=True,
#     #     rivercolor="blue",
#     #     showlakes=True,
#     #     lakecolor="blue",
#     # )
#     return fig

import plotly.graph_objects as go
import plotly.express as px

# Create line map using Plotly
def line_mapbox(df, country, city, start_date, end_date):
    filtered_data = df[(df['Country'] == country) & (df['City'] == city) & (df['Date'] >= start_date) & (df['Date'] <= end_date)]
    # Get the center coordinates for the specified city
    center_lat = filtered_data["Latitude"].mean()
    center_lon = filtered_data["Longitude"].mean()

    fig = go.Figure(go.Scattermapbox(
        lat=filtered_data['Latitude'],
        lon=filtered_data['Longitude'],
        mode='lines+markers',
        text=filtered_data['City'],
        hovertext=filtered_data[['Country', 'Price', 'Date']],
        hoverinfo='text',
        marker=dict(size=10),
        line=dict(width=2),
    ))

    fig.update_layout(
        mapbox_style="carto-positron",
        mapbox_layers=[
            {
                "below": 'traces',
                "sourcetype": "raster",
                "sourceattribution": "United States Geological Survey",
                "source": [
                    "https://basemap.nationalmap.gov/arcgis/rest/services/USGSImageryOnly/MapServer/tile/{z}/{y}/{x}",
                ],
            }
        ],
        mapbox=dict(
            center=dict(lat=center_lat, lon=center_lon),
            zoom=2,
        ),
        margin={"r":1,"t":1,"l":1,"b":1},
    )

    # fig.update_layout(
    #     showcountries=True,
    #     countrycolor="black",
    #     showland=True,
    #     showocean=True,
    #     oceancolor="navy",
    #     showcoastlines=True,
    #     coastlinecolor="gray",
    #     showrivers=True,
    #     rivercolor="blue",
    #     showlakes=True,
    #     lakecolor="blue",
    # )

    return fig

# Create the line chart for price
def create_line_chart(df, country, city, start_date, end_date):
    filtered_data = df[(df['Country'] == country) & (df['City'] == city) & (df['Date'] >= start_date) & (df['Date'] <= end_date)]
    line_chart = filtered_data.hvplot.line(x='Date', y='Price', title=f'Import Prices Per Metric Tonne for {city}',
                                           height=500, width=700
                                          ) #height=300, width=500
    return line_chart

# Create the table showing the values plotted on the price line chart
def create_price_table(df, country, city, start_date, end_date):
    filtered_data = df[(df['Country'] == country) & (df['City'] == city) & (df['Date'] >= start_date) & (df['Date'] <= end_date)]
    table = pn.widgets.DataFrame(filtered_data[['Date', 'Country', 'City', 'Price']].head(5)) #, height=300, width=500
    return table

# Create the interactive Panel dashboard
@pn.depends(country_selection.param.value, city_selection.param.value, calendar.param.value) #date_range_picker.param.value
def update_dashboard(country, city, date_range):
    start_date, end_date = date_range
    # country_map = choropleth_map(df, country, city, start_date, end_date)
    country_map = line_mapbox(df, country, city, start_date, end_date)
    line_chart_price = create_line_chart(df, country, city, start_date, end_date)
    table_price = create_price_table(df, country, city, start_date, end_date) 
    
    return pn.Column(
        pn.Row(country_map, line_chart_price),
        # pn.Row(line_chart_price, table_price),
        # pn.Row(table_price),
        # pn.Row(line_chart_price_quantity, scatter_map_price_quantity),
    )

dashboard = pn.template.FastListTemplate(
    title='Maize Import Prices/MT(USD) Dashboard',
    sidebar=[
        # pn.pane.Markdown("### Maize Import Prices Vs Import Quantity"),
        pn.pane.Markdown("Select Country and City"),
        country_selection,
        city_selection,
        pn.pane.Markdown("Select Date Range"),
        pn.Row(calendar),
        # date_range_picker
    ],
    main=update_dashboard,
    accent_base_color="#88d8b0",
    header_background="#88d8b0",
)

# Show the dashboard
dashboard.servable()