# Query the Lakehouse with Select AI

## Introduction

In this lab, you activate the lakehouse profile, ask a natural-language question, inspect the generated SQL, and then run the approved query.

Estimated Time: 10 minutes

### Objectives

In this lab, you will:

- Activate and verify the Select AI profile
- Generate SQL without running it
- Review and run an approved generated query
- Explore additional lakehouse questions

## Task 1: Activate the Select AI Profile

1. In SQL Developer, open a worksheet for the `LAKE_DEMO` connection.

2. Activate the profile:

    ```sql
    BEGIN
      DBMS_CLOUD_AI.SET_PROFILE('LAKEHOUSE_AZURE_OPENAI');
    END;
    /
    ```

3. Verify the active profile:

    ```sql
    SELECT DBMS_CLOUD_AI.GET_PROFILE
    FROM DUAL;
    ```

4. Confirm that the result is `LAKEHOUSE_AZURE_OPENAI`.

## Task 2: Generate and Review SQL

1. Generate SQL for a business question without running the generated statement:

    ```sql
    SELECT DBMS_CLOUD_AI.GENERATE(
      prompt       => 'Show discounted revenue by customer market segment.',
      profile_name => 'LAKEHOUSE_AZURE_OPENAI',
      action       => 'showsql'
    ) AS generated_sql
    FROM DUAL;
    ```

2. Review the generated statement. Confirm that it:

    - Uses only objects in the approved profile
    - Contains a read-only `SELECT` statement
    - Joins columns that represent the requested business relationship

3. If the generated SQL is appropriate, copy that statement into a new `LAKE_DEMO` worksheet and run it to execute the exact query you reviewed.

4. To generate and run a query in one request, use the same prompt with the `runsql` action. Its SQL can differ from the earlier `showsql` result.

    ```sql
    SELECT DBMS_CLOUD_AI.GENERATE(
      prompt       => 'Show discounted revenue by customer market segment.',
      profile_name => 'LAKEHOUSE_AZURE_OPENAI',
      action       => 'runsql'
    ) AS result
    FROM DUAL;
    ```

    > **Note:** Generative AI output can vary. Use `showsql` and run the reviewed statement directly when you need to control the exact SQL that executes.

## Task 3: Explore Additional Questions

1. Try a movie question with the package API:

    ```sql
    SELECT DBMS_CLOUD_AI.GENERATE(
      prompt       => 'List the top 10 drama movies by views.',
      profile_name => 'LAKEHOUSE_AZURE_OPENAI',
      action       => 'showsql'
    ) AS generated_sql
    FROM DUAL;
    ```

2. Ask a question that joins customer education with movie viewing:

    ```sql
    SELECT DBMS_CLOUD_AI.GENERATE(
      prompt       => 'Which movie was watched most often by customers with a Doctorate education?',
      profile_name => 'LAKEHOUSE_AZURE_OPENAI',
      action       => 'showsql'
    ) AS generated_sql
    FROM DUAL;
    ```

3. After the profile is active, you can also use the `SELECT AI SHOWSQL` syntax. Try one or more of these questions:

    ```sql
    SELECT AI SHOWSQL 'Show total actual sales revenue, transaction count, and average actual price by customer country and genre name, ordered by revenue descending.';

    SELECT AI SHOWSQL 'Compare total revenue, average transaction value, and transaction count by customer age group and gender.';

    SELECT AI SHOWSQL 'Show revenue, transaction count, average discount percent, and average actual price by customer segment name.';

    SELECT AI SHOWSQL 'Find the top 20 customers by total actual sales price for each genre and include customer name, email, country, genre, and transaction count.';

    SELECT AI SHOWSQL 'Compare discount type, average discount percent, and total revenue by income level and genre.';

    SELECT AI SHOWSQL 'Show the app, device, operating system, payment method, and genre combinations that generate the most revenue in each customer country.';

    SELECT AI SHOWSQL 'Show monthly revenue and transaction count by customer segment and genre using DAY_ID.';

    SELECT AI SHOWSQL 'Identify segments with the highest average credit balance, mortgage amount, income, and sales revenue.';

    SELECT AI SHOWSQL 'Compare promotion response rate, total revenue, average discount percent, and average actual price by genre and customer segment.';

    SELECT AI SHOWSQL 'For customers with insufficient funds incidents or late mortgage or rent payments, show transaction count, revenue, average discount, and preferred genre compared with other customers.';
    ```

4. For each prompt, review the generated SQL and identify the tables, views, joins, filters, and aggregations Select AI chose. Check that customer and sales joins use `CUST_ID`, movie joins use `MOVIE_ID`, and revenue uses the sales data requested by the prompt.

## Acknowledgements

- **Author** - Oracle Multicloud Team
- **Last Updated By/Date** - Oracle LiveLabs, September 2026
