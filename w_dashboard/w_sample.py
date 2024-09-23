import streamlit as st
import plotly.express as px
import plotly.figure_factory as ff
import pandas as pd
import os
import warnings
warnings.filterwarnings('ignore')

st.set_page_config(page_title="Superstore!!!", page_icon=":bar_chart:",layout="wide")

st.title(" :bar_chart: Wasoko Super Store Dashboard")
st.markdown('<style>div.block-container{padding-top:1rem;}</style>',unsafe_allow_html=True)

st.markdown("To upload file the column names should read as : day_date, Region, Branch, City, Sub Class, product_description, sell_price_usd. "
            "The Branch represents the Country Name while the Sub Class is the product category")
@st.cache_data
def get_data():
    fl = st.file_uploader(":file_folder: Upload a file",type=(["csv","txt","xlsx","xls"]))
    if fl is not None:
        filename = fl.name
        st.write(filename)
        df = pd.read_excel(filename) #, encoding = "ISO-8859-1"
    else:
        # os.chdir("D:\\kulea_projects")
        # df = pd.read_excel("Sample_Superstore.xls") #, encoding = "ISO-8859-1
        data_url = 'https://drive.google.com/uc?id=1cvJjtauWfchhN7ZiWrkUCuMlABQ0xBzs'
        # https://docs.google.com/spreadsheets/d/1cvJjtauWfchhN7ZiWrkUCuMlABQ0xBzs/edit?usp=sharing&ouid=103208506414606339610&rtpof=true&sd=true
        # df = pd.read_excel("D:\\kulea_projects\\wasoko_retail_prices.xlsx")
        df = pd.read_excel(data_url, sheet_name=0)
    return df 
# data_url = 'https://drive.google.com/uc?id=1cvJjtauWfchhN7ZiWrkUCuMlABQ0xBzs'
# df = pd.read_excel(data_url)
df = get_data()
col1, col2 = st.columns((2))
df["Order Date"] = pd.to_datetime(df["day_date"])

# Getting the min and max date 
startDate = pd.to_datetime(df["Order Date"]).min()
endDate = pd.to_datetime(df["Order Date"]).max()

with col1:
    date1 = pd.to_datetime(st.date_input("Start Date", startDate))

with col2:
    date2 = pd.to_datetime(st.date_input("End Date", endDate))

df = df[(df["Order Date"] >= date1) & (df["Order Date"] <= date2)].copy()

st.sidebar.header("Choose your filter: ")
# Create for Region
region = st.sidebar.multiselect("Pick your Region", df["Region"].unique())
if not region:
    df2 = df.copy()
else:
    df2 = df[df["Region"].isin(region)]

# Create for State
state = st.sidebar.multiselect("Pick the Country", df2["Country"].unique())
if not state:
    df3 = df2.copy()
else:
    df3 = df2[df2["Country"].isin(state)]

# Create for City
city = st.sidebar.multiselect("Pick the Branch",df3["Branch"].unique())

# Filter the data based on Region, State and City

if not region and not state and not city:
    filtered_df = df
elif not state and not city:
    filtered_df = df[df["Region"].isin(region)]
elif not region and not city:
    filtered_df = df[df["Country"].isin(state)]
elif state and city:
    filtered_df = df3[df["Country"].isin(state) & df3["City"].isin(city)]
elif region and city:
    filtered_df = df3[df["Region"].isin(region) & df3["City"].isin(city)]
elif region and state:
    filtered_df = df3[df["Region"].isin(region) & df3["Country"].isin(state)]
elif city:
    filtered_df = df3[df3["City"].isin(city)]
else:
    filtered_df = df3[df3["Region"].isin(region) & df3["Country"].isin(state) & df3["City"].isin(city)]

category_df = filtered_df.groupby(by = ["Sub Class"], as_index = False)["sell_price_usd"].sum()

with col1:
    st.subheader("Category wise Price")
    fig = px.bar(category_df, x = "sell_price_usd", y ="Sub Class", text = ['${:,.2f}'.format(x) for x in category_df["sell_price_usd"]],
                 template = "seaborn", orientation="h")
    st.plotly_chart(fig,use_container_width=True, height = 400)

with col2:
    st.subheader("Country wise Price")
    fig = px.pie(filtered_df, values = "sell_price_usd", names = "Country", hole = 0.5)
    fig.update_traces(text = filtered_df["Country"], textposition = "outside")
    st.plotly_chart(fig,use_container_width=True, height=300)

cl1, cl2 = st.columns((2))
with cl1:
    with st.expander("Category_ViewData"):
        st.write(category_df.style.background_gradient(cmap="Blues"))
        csv = category_df.to_csv(index = False).encode('utf-8')
        st.download_button("Download Data", data = csv, file_name = "Category.csv", mime = "text/csv", help = 'Click here to download the data as a CSV file')

with cl2:
    with st.expander("Region_ViewData"):
        region = filtered_df.groupby(by = "Region", as_index = False)["sell_price_usd"].sum()
        st.write(region.style.background_gradient(cmap="Oranges"))
        csv = region.to_csv(index = False).encode('utf-8')
        st.download_button("Download Data", data = csv, file_name = "Region.csv", mime = "text/csv", help = 'Click here to download the data as a CSV file')
        
filtered_df["month_year"] = filtered_df["Order Date"].dt.to_period("M")
st.subheader('Time Series Analysis')

# linechart = pd.DataFrame(filtered_df.groupby(filtered_df["month_year"].dt.strftime("%Y : %b"))["sell_price_usd"].sum()).reset_index()
filtered_df["month_year"] = filtered_df["month_year"].dt.strftime("%Y : %b")
linechart = pd.DataFrame(filtered_df.groupby(['month_year', 'Sub Class'])["sell_price_usd"].sum()).reset_index()
fig2 = px.line(linechart, x = "month_year", y="sell_price_usd",color="Sub Class", labels = {"sell_price_usd": "Amount"},height=500, width = 1000,template="gridon")

# Customize chart appearance
fig2.update_layout(legend_title_text="Commodity", legend=dict(orientation="h", yanchor="bottom", y=1.02, xanchor="right", x=1),
                   margin={"r": 20, "t": 30, "l": 20, "b": 30})

st.plotly_chart(fig2,use_container_width=True)

with st.expander("View Data of TimeSeries:"):
    st.write(linechart.T.style.background_gradient(cmap="Blues"))
    csv = linechart.to_csv(index=False).encode("utf-8")
    st.download_button('Download Data', data = csv, file_name = "TimeSeries.csv", mime ='text/csv')

# Create a treem based on Region, category, sub-Category
st.subheader("Hierarchical view of Price using TreeMap")
fig3 = px.treemap(filtered_df, path = ["Region","Sub Class","product_description"], values = "sell_price_usd",hover_data = ["sell_price_usd"],
                  color = "product_description")
fig3.update_layout(width = 800, height = 650)
st.plotly_chart(fig3, use_container_width=True)

# chart1, chart2 = st.columns((2))
# with chart1:
#     st.subheader('Segment wise Price')
#     fig = px.pie(filtered_df, values = "sell_price_usd", names = "Sub Class", template = "plotly_dark")
#     fig.update_traces(text = filtered_df["Sub Class"], textposition = "inside")
#     st.plotly_chart(fig,use_container_width=True)

# with chart2:
#     st.subheader('Category wise Price')
#     fig = px.pie(filtered_df, values = "sell_price_usd", names = "product_description", template = "gridon")
#     fig.update_traces(text = filtered_df["product_description"], textposition = "inside")
#     st.plotly_chart(fig,use_container_width=True)

st.subheader(":point_right: Month wise Sub-Category Prices Summary")
with st.expander("Summary_Table"):
    df_sample = df[0:5][["Region","Country","Branch","Sub Class","sell_price_usd"]] #,"Profit","Quantity"
    fig = ff.create_table(df_sample, colorscale = "Cividis")
    st.plotly_chart(fig, use_container_width=True)

    st.markdown("Month wise Sub-Category Table")
    filtered_df["month"] = filtered_df["Order Date"].dt.month_name()
    sub_category_Year = pd.pivot_table(data = filtered_df, values = "sell_price_usd", index = ["product_description"],columns = "month")
    st.write(sub_category_Year.style.background_gradient(cmap="Blues"))

# # Create a scatter plot
# data1 = px.scatter(filtered_df, x = "sell_price_usd", y = "sell_price_usd", size = "sell_price_usd")
# data1['layout'].update(title="Relationship between Price and Dollar Rate using Scatter Plot.",
#                        titlefont = dict(size=20),xaxis = dict(title="Price",titlefont=dict(size=19)),
#                        yaxis = dict(title = "Price", titlefont = dict(size=19)))
# st.plotly_chart(data1,use_container_width=True)

# with st.expander("View Data"):
#     st.write(filtered_df.iloc[:500,1:20:2].style.background_gradient(cmap="Oranges"))

# # Download orginal DataSet
# csv = df.to_csv(index = False).encode('utf-8')
# st.download_button('Download Data', data = csv, file_name = "Data.csv",mime = "text/csv")