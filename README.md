# Retail Sales & Profitability Analysis

## Project Overview

This project presents an end-to-end retail sales and profitability analysis using Python, SQL Server, and Power BI.

The main objective is to analyse sales performance, identify profitable and loss-making products, investigate discount strategies, and examine customer return patterns.

The project follows a complete data analysis workflow, from data exploration and cleaning to SQL analysis, interactive dashboard development, and business recommendations.

**Dataset:** Sample Superstore (demonstration dataset)

**Tools Used:**
- Python — Data Cleaning and Exploratory Data Analysis (EDA)
- SQL Server — Database Management and SQL Analysis
- Power BI — Data Visualisation and Interactive Dashboards
- VS Code — Python Development and Project Documentation

**Final Deliverable:** An interactive Power BI dashboard presenting key business insights and recommendations.

## Project Structure

The project is organised into the following folders and files:

```text
Retail Sales & Profitability Analysis/
│
├── data/
│   └── processed/
│       ├── orders_clean.csv
│       ├── returns_clean.csv
│       └── people_clean.csv
│
├── sql/
│   ├── 01_database_setup.sql
│   ├── 02_sales_analysis.sql
│   └── 03_returns_analysis.sql
│
├── dashboard/
│   └── Retail_Sales_Profitability.pbix
│
├── 01_data_understanding.ipynb
├── 02_orders_eda.ipynb
├── 03_returns_eda.ipynb
├── 04_data_integration.ipynb
│
└── README.md
```

### Folder Description

**data/processed/**

Contains the prepared datasets used for SQL analysis and Power BI reporting.

**sql/**

Contains SQL scripts for database setup, sales analysis, profitability analysis, and returns analysis.

**dashboard/**

Contains the Power BI report with five interactive dashboard pages.

**Python Notebooks**

Document the complete Python workflow, including data understanding, exploratory data analysis, returns analysis, and data integration.

**README.md**

Provides project documentation, methodology, key findings, and business recommendations.

## Business Questions

This project aims to answer the following business questions:

1. **Sales Performance**
   - How have sales and profits changed over time?
   - Which regions and product categories generate the highest sales?

2. **Product Profitability**
   - Which product categories and subcategories are the most profitable?
   - Which products generate the greatest losses?

3. **Discount Analysis**
   - How do different discount levels relate to profit margins?
   - Are higher discounts associated with lower profitability?

4. **Returns Analysis**
   - What percentage of orders are returned?
   - Which regions and product categories have the highest return rates?
   - How do return rates vary over time?

5. **Business Recommendations**
   - What actions could improve profitability?
   - Which areas should the business prioritise to reduce losses and investigate customer returns?

## Data Understanding & Data Cleaning

### Dataset Description

The project uses the Sample Superstore dataset, which contains retail sales, customer orders, product information, discounts, profits, and returns.

The analysis focuses on US orders and uses three main datasets:

- **Orders:** Sales transactions, products, customers, discounts, and profits.
- **Returns:** Information identifying returned orders.
- **People:** Regional manager information.

### Data Exploration

Python and pandas were used to explore the datasets and assess data quality.

The main activities included:

- Examining dataset structures and column names.
- Reviewing data types.
- Checking missing values and duplicate records.
- Inspecting numerical variables such as Sales, Profit, Quantity, and Discount.
- Identifying relationships between datasets.
- Exploring sales, profitability, and return patterns.

### Data Preparation

The data preparation process focused on creating consistent datasets for further analysis.

Key activities included:

- Filtering Orders to US records.
- Reviewing data quality issues.
- Preparing the Orders, Returns, and People datasets.
- Checking the fields used to connect the tables.
- Exporting processed CSV files for SQL Server.

### Python Notebooks

The Python workflow is documented in the following notebooks:

- `01_data_understanding.ipynb`
- `02_orders_eda.ipynb`
- `03_returns_eda.ipynb`
- `04_data_integration.ipynb`

These notebooks document the data exploration, analysis, and preparation stages.

## SQL Server — Database & Analysis

### Database Setup

After preparing the datasets in Python, the processed CSV files were imported into SQL Server.

A database named `Retail_Sales_Analysis` was created to organise the data and perform business analysis.

The database contains three main tables:

- **Orders:** Sales transactions, product details, discounts, quantities, and profits.
- **Returns:** Information about returned orders.
- **People:** Regional manager information.

The tables were connected using their relevant fields to support analysis across sales, regions, and returns.

### SQL Analysis

SQL queries were developed to investigate key business performance indicators and identify patterns in the data.

The analysis covered:

**1. Sales Performance**
- Total sales and total profit.
- Sales performance by year.
- Sales and profitability by region.
- Sales performance by product category.

**2. Product Profitability**
- Profitability by category and subcategory.
- Identification of loss-making products.
- Comparison of sales and profit margins.

**3. Discount Analysis**
- Profit margins across different discount levels.
- Identification of discount groups associated with negative profitability.

**4. Returns Analysis**
- Number of returned orders.
- Overall return rate.
- Return rates by region and product category.

### SQL Scripts

The SQL workflow is documented in:

- `01_database_setup.sql` — Database preparation and setup.
- `02_sales_analysis.sql` — Sales and profitability analysis.
- `03_returns_analysis.sql` — Customer returns analysis.

The SQL results were used to support the business findings presented in the Power BI dashboard.

## Power BI Dashboard

An interactive Power BI dashboard was developed to visualise retail sales performance, profitability, discounts, and customer returns.

The dashboard consists of five pages, each focusing on a different aspect of business performance.

### 1. Executive Overview

Provides an overview of the company's performance through key performance indicators (KPIs):

- Total Sales
- Total Profit
- Profit Margin %
- Total Orders
- Total Units Sold
- Average Order Value

Additional visualisations include monthly sales trends, profit margins by category, and regional sales and profitability.

An interactive Year slicer allows users to analyse performance across different periods.

![Executive Overview](dashbourd\screenshots\01_executive_overview.png)

### 2. Sales & Product Performance

Focuses on identifying the best-performing product categories and products.

Key visualisations include:

- Sales by Category
- Top 10 Products by Sales
- Top 10 Subcategories by Sales
- Yearly Sales Performance

An interactive Category slicer allows users to explore individual product categories.

![Sales & Product Performance](dashbourd\screenshots\02_sales_product_performance.png)

### 3. Profitability & Discounts

Examines profitability across products and geographic locations.

Key visualisations include:

- Profitability by Category and Subcategory
- Profitability by State (USA Map)
- Profit Margin by Discount Level
- Bottom 10 Products by Profit

This page helps identify loss-making products, low-profitability locations, and discount levels associated with negative margins.

![Profitability & Discounts](dashbourd\screenshots\03_profitability_discounts.png)

### 4. Returns Analysis

Investigates customer return patterns and their distribution across regions, categories, and time.

Key visualisations include:

- Total Returned Orders
- Overall Return Rate %
- Return Rate by Region
- Returns by Category — Volume & Rate
- Monthly Return Rate Trend

Interactive filtering allows users to investigate returns during different years.

![Returns Analysis](dashbourd\screenshots\04_returns_analysis.png)

### 5. Business Insights & Recommendations

Summarises the main findings from the analysis and translates them into practical business recommendations.

The page highlights:

- Overall Business Performance
- Product Profitability
- Discount Analysis
- Returns Performance

It also provides recommendations for reviewing pricing strategies, improving product profitability, and investigating regional returns.

![Business Insights & Recommendations](dashbourd\screenshots\05_business_insights_recommendations.png)

### Dashboard Features

The Power BI report includes:

- Interactive slicers and filters.
- DAX measures for business KPIs.
- Conditional formatting to highlight positive and negative profitability.
- Geographic analysis of sales and profit.
- Time-based performance analysis.
- Business insights and actionable recommendations.

## Key Findings & Business Recommendations

### Key Findings

**1. Overall Business Performance**

- Total Sales: **$2.30M**
- Total Profit: **$286.40K**
- Profit Margin: **12.47%**

The business is profitable overall, but profitability varies significantly across product categories and regions.

**2. Product Profitability**

- Technology has the highest total profit at approximately **$145.45K**.
- Furniture has the lowest profit margin at **2.49%**.
- Tables generated a loss of **$17.73K**.
- Bookcases generated a loss of **$3.47K**.

These findings highlight opportunities to improve profitability in specific product categories.

**3. Discount Analysis**

- Products sold without discounts achieved a **29.51%** profit margin.
- Discounts between 20% and 40% were associated with a **−15.30%** profit margin.
- Discounts between 40% and 60% were associated with a **−40.74%** profit margin.

Higher discount levels were associated with lower profitability. However, these results do not establish that discounts alone caused the losses.

**4. Returns Analysis**

- Total Returned Orders: **296**
- Overall Return Rate: **5.91%**
- West Region Return Rate: **11.73%**

The West region recorded the highest return rate, indicating an area that may benefit from further investigation.

### Business Recommendations

**1. Review Pricing and Discount Strategies**

Evaluate discount policies, particularly for products receiving discounts above 40%.

Test alternative discount strategies and monitor their effects on sales and profitability.

**2. Improve Product Profitability**

Focus on loss-making subcategories, particularly Tables and Bookcases.

Review pricing, product costs and sales performance to identify opportunities to reduce losses.

**3. Investigate Regional Returns**

Prioritise the West region for further investigation.

Analyse potential factors such as product quality, delivery issues and customer satisfaction before implementing corrective actions.

### Business Conclusion

Strong sales performance does not always translate into high profitability.

By combining sales, profitability, discount and return analysis, this project identifies opportunities to improve business performance and support data-driven decision-making.

