Project Name
------------

**The Ruby code challenge involves processing JSON files containing user and company data to create an output.txt file.**


About
-----

The criteria for this output file require that active users belonging to a company should receive a token top-up equal to the specified amount in the company's "top_up" field. If a user's company has an email status of true, the output should indicate that the user was sent an email (without actually sending emails). However, users with an email status of false should not receive an email, regardless of the company's email status. The final output should have companies ordered by company ID and users ordered alphabetically by last name.


Prerequisites
-------------

- **Ruby 2.7 or higher**

Installation and Running
------------

Provide step-by-step instructions on how to install your project. For example:

1. **Clone the repository:**

    ```
    git clone git@github.com:satyakaam/ruby_tek_rek.git
    ```

2. **Change to the project directory:**

    ```
    cd TAKEHOME
    ```

3. **Running Challenge**

    ```
    ruby challenge.rb
    ```

4. **Running Tests**

    ```
    ruby tests/user.rb
    ruby tests/company.rb
    ```