   CREATE TABLE CUENTAS                                          
   (                                                             
       ID_CUENTA          INTEGER       NOT NULL,                
       ID_CLIENTE         INTEGER       NOT NULL,                
       IBAN               CHAR(24)      NOT NULL,                
       SALDO              DECIMAL(15,2) NOT NULL,                
       ESTADO             CHAR(1)       NOT NULL,                
       FECHA_APERTURA     DATE          NOT NULL,                
       PRIMARY KEY (ID_CUENTA),                                  
       FOREIGN KEY (ID_CLIENTE)                                  
           REFERENCES CLIENTES(ID_CLIENTE)                       
   )                                                             
   IN IBMUSER1.CLIENTES;                                         
   CREATE UNIQUE INDEX CUENTAS_IPK ON CUENTAS                    
   (                                                             
       ID_CUENTA                                                 
   );    
                                                          
   CREATE TABLE MOVIMIENTOS                                        
   (                                                               
       ID_MOVIMIENTO      INTEGER        NOT NULL,                 
       ID_TRANSFERENCIA   INTEGER        NOT NULL,                 
       ID_CUENTA          INTEGER        NOT NULL,                 
       TIPO_MOV           CHAR(1)        NOT NULL,                 
       IMPORTE            DECIMAL(15,2)  NOT NULL,                 
       FECHA_MOV          DATE           NOT NULL,                 
       PRIMARY KEY (ID_MOVIMIENTO)                                 
   )                                                               
   IN IBMUSER1.CLIENTES;                                           
   CREATE UNIQUE INDEX MOVIMIENTOS_IPK ON MOVIMIENTOS              
   (                                                               
       ID_MOVIMIENTO                                               
   );                
    CREATE TABLE TRANSFERENCIAS                              
   (                                                        
       ID_TRANSFERENCIA   INTEGER        NOT NULL,          
       CTA_ORIGEN         INTEGER        NOT NULL,          
       CTA_DESTINO        INTEGER        NOT NULL,          
       IMPORTE            DECIMAL(15,2)  NOT NULL,          
       FECHA_TRANSF       DATE           NOT NULL,          
       ESTADO             CHAR(1)        NOT NULL,          
       PRIMARY KEY (ID_TRANSFERENCIAS)                      
   )                                                        
   IN IBMUSER1.CLIENTES;                                    
   CREATE UNIQUE INDEX TRANSFERENCIAS_IPK                   
   ON TRANSFERENCIAS                                        
   (                                                        
       ID_TRANSFERENCIA                                     
   );                       
   CREATE TABLE CLIENTES                                  
   (                                                      
       ID_CLIENTE      INTEGER      NOT NULL,             
       DNI_NIF         CHAR(9)      NOT NULL,             
       NOMBRE          VARCHAR(40)  NOT NULL,             
       APELLIDO1       VARCHAR(40)  NOT NULL,             
       APELLIDO2       VARCHAR(40),                       
       FECHA_NAC       DATE         NOT NULL,             
       TELEFONO        VARCHAR(15),                       
       EMAIL           VARCHAR(60),                       
       ESTADO          CHAR(1)      NOT NULL,             
       FECHA_ALTA      DATE         NOT NULL,             
       PRIMARY KEY (ID_CLIENTE)                           
   )                                                      
  IN IBMUSER1.CLIENTES;                                   
  CREATE UNIQUE INDEX CLIENTES_IPK ON CLIENTES            
  (                                                       
     ID_CLIENTE                                           
  );                                                                                                                                     
