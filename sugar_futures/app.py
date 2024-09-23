# import the libraries
import numpy as np
import pandas as pd
import panel as pn
import hvplot.pandas
from bokeh.plotting import figure
# from bokeh.io import out_notebook, show
import holoviews as hv
from holoviews import dim
import jupyter_bokeh

# Load the data
data = pd.read_csv("D:\kulea_projects\sugar_futures\Sugar_Futures.csv", parse_dates=["Report_Date_as_YYYY_MM_DD"],) 
                #    date_format="%Y-%m-%d")
data.head()

data[['Year', 'Report_Week']] = data['YYYY Report Week WW'].str.split(' Report Week ', expand=True)
# data.drop('YYYY Report Week WW', axis=1, inplace=True)
data[['Year', 'Report_Week']].tail()

data['Open_Interest_All'] = data['Open_Interest_All'].str.replace(',', '').astype(int)
data['Prod_Merc_Positions_Long_All'] = data['Prod_Merc_Positions_Long_All'].str.replace(',', '').astype(int)
data['Prod_Merc_Positions_Short_All'] = data['Prod_Merc_Positions_Short_All'].str.replace(',', '').astype(int)
# data['Traders_Prod_Merc_Short_All'] = data['Traders_Prod_Merc_Short_All'].str.replace(',', '').astype(int)
# data['Traders_Prod_Merc_Short_All'] = data['Traders_Prod_Merc_Long_All'].str.replace(',', '').astype(int)

# Create a Panel DataFrame object
df_pane = pn.pane.DataFrame(data)

# Create a calendar slider
calendar_slider = pn.widgets.DateRangeSlider(name="Date Range", start=data['Report_Date_as_YYYY_MM_DD'].min(),
                                             end=data['Report_Date_as_YYYY_MM_DD'].max(),
                                             value=(data['Report_Date_as_YYYY_MM_DD'].min(), data['Report_Date_as_YYYY_MM_DD'].max()))

# Create charts for various questions
# open_interest_chart = data.hvplot(x='Report_Date_as_YYYY_MM_DD', y=np.log(data['Open_Interest_All']), kind='line')
open_interest_chart = data.hvplot(x='Report_Date_as_YYYY_MM_DD', y='Open_Interest_All', kind='line')
prod_positions_chart = data.hvplot(
    x='Report_Date_as_YYYY_MM_DD', 
    y=['Prod_Merc_Positions_Long_All', 'Prod_Merc_Positions_Short_All', 'Open_Interest_All',], 
    kind='line')

trader_positions_chart_ = data.hvplot(
    x='Year', 
    y=['Traders_Prod_Merc_Long_All', 'Traders_Prod_Merc_Short_All',],# 'Open_Interest_All',], 
    kind='scatter',
    width=800)    

# concentration_vs_pct_open_interest_chart = data.hvplot(x='Report_Date_as_YYYY_MM_DD', y=['Conc_Gross_LE_4_TDR_Long_All', 'Pct_of_Open_Interest_All'], kind='line')
scatter_plot= hv.Scatter(
    data, kdims=['Traders_Prod_Merc_Long_All', 'Traders_Prod_Merc_Short_All'], 
    vdims=['Open_Interest_All', 'Report_Week'])
# Customize the plot appearance
scatter_plot.opts(
    color='blue',        # Color of the scatter points
    size=dim('Open_Interest_All') * 0.000001,  # Size of the markers based on Open Interest (scaled for better visualization)
    # size=10,
    marker='o',          # Marker style
    width=700,           # Width of the plot
    # height=800,          # Height of the plot
    xlabel='Producer/Merchant Long Positions',
    ylabel='Producer/Merchant Short Positions',
    title='Relationship between Traders, Open Interest, and Positions'
)
seasonal_trader_positions_chart = data.hvplot(x='Report_Week', y=['Traders_Prod_Merc_Short_All', 'Traders_Prod_Merc_Long_All'], by='Year', kind='bar', stacked=True)
# open_interest_change = data.hvplot(x='YYYY Report Week WW', y='Change_in_Open_Interest_All', kind='bar')

# Create the dashboard layout
dashboard_layout = pn.Row(
    pn.Column(
        calendar_slider,
        width=300  # Adjust the width of the sidebar
    ),
    pn.Column(
        pn.Row(open_interest_chart, prod_positions_chart),
        width_policy="max",  # Adjust the width policy
        height=600  # Adjust the height
    )
)

# Show the dashboard
dashboard_layout.servable()