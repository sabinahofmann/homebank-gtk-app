CSV convertor for HomeBank
=======================================
It's a desktop app that converts any CSV transaction reports from a bank account. The converted CSV-file 
can be imported by the personal finance software [HomeBank](http://homebank.free.fr/en/index.php)

# Installation
Please checkout the project at your home directory from GitHub master branch.

By default two exemplary account configurations are generated. One of them is for
the germany credit bank DKB account and the other one is for the bank Ing. 

Both accounts can be modified or deleted at any time. Feel free.

### Requirements
This code is written in ruby and gtk4.

Please make sure to have ruby **>= 3.0** and the **gem gkt4** installed on your system.

- gem install gtk4

###### Important Note:
It has been tested on mac M1 with ruby version 3.2.2 .

# Getting Started
Call the script directly from the checked out project-directory with:

```
  $ ./homebank-gtk
```

A main window appears with a menu and two generated examples of confirguation accounts.

![Main window](/docu/main_window.png)

For the desired report of your bank of choice, you have to create or use an exists 
configuration account. Please push the button "Add account", "Edit Account" or "Import CSV".

![New account](/docu/add_account.png)

In edit mode of an configuration account enter the linenumber in the field "Start line at". It stands
for the start of the entries of your transactions in the exported CSV-file.
The fields "Date", "Payment", "Tag", "Payee", "Memo", "Amount", "Category" are use
to determine the columns in the exported CVS file - more explanations see [HomeBank CSV file format](http://homebank.free.fr/help/misc-csvformat.html)

![Edit mode](/docu/edit_mode.png)

For converting your exported file to a readable format for HomeBank application use the button "Import CSV"
in the main window.

![Import window](/docu/import_csv.png)

Select the desired CSV exported report and press the button "Convert" to start the process. 
The newly generated CSV file will be stored in the same directory as the original file and has the file 
extension "<account-name>-homebank-import.cvs".

![Conert CSV](/docu/convert_csv.png)

###### Basic HomeBank knowledge is highly recommended

##### Example of DKB CSV report:

```
1 "Kontonummer:";"DExxxxxxxxxxxxxxxxxxxx / Girokonto";
2 
3 "Von:";"xx.xx.xxxx";
4 "Bis:";"xx.xx.xxxx";
5 "Kontostand vom xx.xx.xxxx:";"1,00 EUR";
6 
7 "Buchungstag";"Wertstellung";"Buchungstext";"Auftraggeber / Beguenstigter";"Verwendungszweck";"Kontonummer";"BLZ";"Betrag (EUR)";"Gleaubiger-ID";"Mandatsreferenz";"Kundenreferenz";
8 "xx.xx.xxxx";"xx.xx.xxxx";"Gutschrift";"credit card";"xxxx-xxxx xxx xxx";"xxxxxx";"xxxxxx";"0,01";"";"";"";
9 "xx.xx.xxxx";"xx.xx.xxxx";"Lastschrift";"paypal";"xxxx-xxxx xxx xxx";"xxxxxx";"xxxxxx";"-14,40";"";"";"";
```

The confirguation of this file is:
![Edit mode](/docu/edit_mode.png)

##### Result after converting DKB CSV report into readable CSV file for HomeBank:

```
1 xx-xx-xxxx;0;"";credit card;xxxx-xxxx xxx xxx;0,01;Gutschrift;credit card
2 xx-xx-xxxx;0;"";paypal;xxxx-xxxx xxx xxx;-14,40;Lastschrift;paypal
```

## Questions or problems?

If you have any issues with cvs convertor which you cannot solve by reading the readme, please add an issue on GitHub.

## Contributing

Contributions are more than welcome! Feel free to fork and submit a new feature-branch as pull request. 
If you encounter any bugs or non expected behaviour, please open a GitHub issue.

