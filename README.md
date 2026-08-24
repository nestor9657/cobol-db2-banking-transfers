# COBOL + DB2 Banking Transfer System

## Overview

This project is a simulated banking transfer processing system developed using **COBOL and IBM DB2** in a mainframe environment.

The application processes pending banking transfers, validates source and destination accounts, checks available balances, updates account balances, records account movements, and updates the transfer status after successful processing.

The project demonstrates a traditional **COBOL + DB2 batch processing workflow**, including DB2 precompilation, DBRM generation, BIND, and program execution.

---

## Technologies

* COBOL
* IBM DB2
* Embedded SQL
* JCL
* DCLGEN
* z/OS Mainframe Environment

---

## Database Tables

The application works with the following DB2 tables:

| Table      | Description                           |
| ---------- | ------------------------------------- |
| `CLIENTES` | Customer information                  |
| `CUENTAS`  | Bank account information and balances |
| `MOVIMIEN` | Account movement history              |
| `TRANSFE`  | Banking transfer information          |

---

## COBOL Program

### `TRANS02`

`TRANS02` is the main COBOL program responsible for processing banking transfers.

The program uses embedded SQL to interact with DB2 and performs the main business logic required to process each pending transfer.

### Main Processing Flow

1. Retrieve pending transfers from `TRANSFE`.
2. Validate the source account.
3. Validate the destination account.
4. Check the available balance.
5. Update the source account balance.
6. Update the destination account balance.
7. Record the transaction in `MOVIMIEN`.
8. Update the transfer status in `TRANSFE`.
9. Handle DB2 return codes using `SQLCODE`.

---

## DCLGEN Copybooks

The project uses DCLGEN-generated copybooks corresponding to the DB2 tables:

```text
CLIENTES
CUENTAS
MOVIMIEN
TRANSFE
```

These copybooks provide the COBOL data structures required to work with the DB2 table definitions.

---

## Mainframe Processing Flow

The project follows a traditional COBOL/DB2 application lifecycle:

```text
COBOL Source
     │
     ▼
DB2 Precompile
     │
     ▼
DBRM Generation
     │
     ▼
DB2 BIND
     │
     ▼
Load Module
     │
     ▼
Program Execution
     │
     ▼
DB2 Transfer Processing
```

---

## JCL

### Compile and BIND

The JCL member:

```text
TRANS02
```

is used to perform the COBOL/DB2 precompilation process and DB2 BIND.

The JCL uses the `DSNHICOB` procedure for the COBOL + DB2 precompile process and generates the DBRM used during the BIND step.

The DB2 plan used by the application is:

```text
TRANS02L
```

### Execution

The execution JCL is:

```text
RUNTRN
```

The program is executed through `IKJEFT01` using the DB2 subsystem:

```text
DB9G
```

and the DB2 plan:

```text
TRANS02L
```

The load module is executed from:

```text
IBMUSER.NESTOR.RUNLIB.LOAD
```

---

## Project Structure

```text
cobol-db2-banking-transfers/
│
├── COBOL/
│   └── TRANS02
│
├── COPYBOOKS/
│   ├── CLIENTES
│   ├── CUENTAS
│   ├── MOVIMIEN
│   └── TRANSFE
│
├── JCL/
│   ├── TRANS02
│   └── RUNTRN
│
├── DB2/
│   ├── CLIENTES
│   ├── CUENTAS
│   ├── MOVIMIEN
│   └── TRANSFE
└── README.md
```

---

## Screenshots

### COBOL Program

Example of the `TRANS02` COBOL program and its embedded DB2 SQL logic.

![COBOL Program](screenshots/cobol-program.png)

### Compile and BIND

JCL execution showing the COBOL/DB2 precompile and BIND process.

![Compile and BIND](screenshots/compile-bind.png)

### Program Execution

Execution of `TRANS02` using the `RUNTRN` JCL.

![Program Execution](screenshots/program-execution.png)

### DB2 Results

DB2 results showing the processing of banking transfers and account movements.

![DB2 Results](screenshots/db2-results.png)

---

## DB2 Integration

The application uses **embedded SQL** inside the COBOL program to communicate with DB2.

The program uses SQL operations such as:

* `SELECT`
* `UPDATE`
* `INSERT`
* Cursor processing
* DB2 return code validation through `SQLCODE`

This allows the COBOL batch program to interact directly with the banking database and process financial transactions.

---

## Error Handling

The program validates DB2 operations using `SQLCODE` after SQL statements.

This allows the application to identify successful operations and handle situations such as invalid accounts, insufficient funds, or unsuccessful database operations.

---

## Objective

The objective of this project is to demonstrate practical knowledge of:

* COBOL programming
* IBM DB2
* Embedded SQL
* DB2 cursors
* DCLGEN
* JCL
* DB2 precompilation
* DBRM generation
* DB2 BIND
* Batch processing
* Banking transaction processing
* Mainframe application architecture

This project is part of my **COBOL / Mainframe Developer portfolio** and is designed to simulate a real-world banking transfer processing workflow.
├── SREENSHOTS
│   ├── The main loop <img width="1230" height="923" alt="image" src="https://github.com/user-attachments/assets/22d2aad1-a4a6-40ff-8ad6-79a33fdc9ee5" />
│   └── TRANS02 <img width="1230" height="923" alt="image" src="https://github.com/user-attachments/assets/0418e18f-6422-468b-bdbb-f19a7df183ac" />
│   └──Successful Compilation <img width="1230" height="923" alt="image" src="https://github.com/user-attachments/assets/ede266c6-a673-4412-bce6-73a98712ace3" />
│   └──Successful Compilation <img width="1230" height="923" alt="image" src="https://github.com/user-attachments/assets/75be1228-5fb3-438f-b889-f5426f67ee96" />



