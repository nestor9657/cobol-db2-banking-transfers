   IDENTIFICATION DIVISION.                                        
   PROGRAM-ID. TRANS02.                                            
   DATA DIVISION.                                                  
   WORKING-STORAGE SECTION.                                        
   01  WS-CONTADOR           PIC 9(5) VALUE 0.                     
   01  WS-SALDO-ORIGEN       PIC S9(13)V99 COMP-3 VALUE 0.         
   01  WS-SALDO-DESTINO      PIC S9(13)V99 COMP-3 VALUE 0.         
   01  WS-NUEVO-ID-MOV       PIC S9(9) COMP VALUE 0.               
   01  WS-ERROR              PIC X VALUE "N".                      
           EXEC SQL                                                
               INCLUDE SQLCA                                       
           END-EXEC.                                               
           EXEC SQL                                                
               INCLUDE CLIENTES                                    
           END-EXEC.                                               
           EXEC SQL                                                
               INCLUDE CUENTAS                                     
           END-EXEC.                                               
           EXEC SQL                                                
               INCLUDE MOVIMIEN                                    
           END-EXEC.                                               
           EXEC SQL                                                
               INCLUDE TRANSFE                                     
           END-EXEC.                                               
   PROCEDURE DIVISION.                                             
   INICIO.                                                         
             DISPLAY "========================================".   
             DISPLAY " INICIO PROCESO TRANSFERENCIAS PENDIENTES".  
             DISPLAY "========================================".   
           EXEC SQL                                                
            DECLARE C-TRANSFERENCIAS CURSOR FOR                    
                 SELECT ID_TRANSFERENCIA,                          
                        CTA_ORIGEN,                                
                        CTA_DESTINO,                               
                        IMPORTE,                                   
                        FECHA_TRANSF,                              
                        ESTADO                                     
                   FROM TRANSFERENCIAS                             
                             FECHA_TRANSF,                             
                            ESTADO                                    
                       FROM TRANSFERENCIAS                            
                    WHERE ESTADO ="P"                                 
                    ORDER BY ID_TRANSFERENCIA                         
                 END-EXEC.                                            
                 EXEC SQL                                             
                     OPEN C-TRANSFERENCIAS                            
                 END-EXEC.                                            
                 IF SQLCODE NOT = 0                                   
                     DISPLAY "ERROR OPEN CURSOR"                      
                     DISPLAY "SQLCODE =" SQLCODE                      
                     DISPLAY "SQLSTATE=" SQLSTATE                     
                     STOP RUN                                         
                 END-IF.                                              
                 PERFORM LEER-TRANSFERENCIA                           
                 PERFORM UNTIL SQLCODE = 100                          
                     IF SQLCODE = 0                                   
                        PERFORM PROCESAR-TRANSFERENCIA                
                     END-IF                                           
                     PERFORM LEER-TRANSFERENCIA                       
                END-PERFORM.                                          
                                                                      
               EXEC SQL                                               
                 CLOSE C-TRANSFERENCIAS                               
               END-EXEC.                                              
                 DISPLAY "========================================".  
                                                                      
                 DISPLAY "TRANSFERENCIAS PROCESADAS: " WS-CONTADOR.   
                                                                      
                 DISPLAY " FIN DEL PROCESO".                          
                 DISPLAY "========================================".  
                                                                      
        LEER-TRANSFERENCIA.                                           
                EXEC SQL                                              
                      FETCH  C-TRANSFERENCIAS                         
                      INTO :WP-TRANSFE1,                              
                           :WP-TRANSFE2,                              
                           :WP-TRANSFE3, 
                           :WP-TRANSFE4,                            
                        :WP-TRANSFE5,                            
                        :WP-TRANSFE6                             
             END-EXEC.                                           
             IF SQLCODE = 100 OR SQLCODE NOT = 0                 
               MOVE "S" TO WS-ERROR                              
             END-IF.                                             
     PROCESAR-TRANSFERENCIA.                                     
              MOVE "N" TO WS-ERROR.                              
              DISPLAY "----------------------------------------".
                                                                 
              DISPLAY "TRANSFERENCIA: " WP-TRANSFE1.             
              DISPLAY "ORIGEN:        " WP-TRANSFE2.             
              DISPLAY "DESTINO:       " WP-TRANSFE3              
              DISPLAY "IMPORTE:       " WP-TRANSFE4.             
   *---------------------------------------------                
   * BUSCAR CUENTA DE ORIGEN                    *                
   *---------------------------------------------                
             EXEC SQL                                            
                SELECT SALDO                                     
                  INTO :SP-CUENTAS4                              
                  FROM CUENTAS                                   
                WHERE ID_CUENTA = :WP-TRANSFE2                   
            END-EXEC.                                            
                                                                 
            IF SQLCODE NOT = 0                                   
               DISPLAY " ERROR: NO EXISTE CUENTA DE ORIGEN"      
               MOVE "S" TO WS-ERROR                              
            END-IF.                                              
   *--------------------------------------------                 
   * BUSCAR CUENTA DE DESTINO                                    
   *--------------------------------------------                 
            IF WS-ERROR = "N"                                    
                                                                 
              EXEC SQL                                           
                SELECT SALDO                                     
                INTO :SP-CUENTAS4                                
               FROM CUENTAS                                      
               WHERE ID_CUENTA = :WP-TRANSFE3  
             END-EXEC                                             
           END-IF.                                               
  *-----------------------------------                           
  *   COMPROBAR ORIGEN DEL SALDO                                 
  *-----------------------------------                           
  * NOTA:                                                        
  * AQUI NECESITAMOS CONSERVAR EL SALDO DE ORIGEN ANTES DE       
  * CONSULTAR EL DESTINO. POR ESO UTILIZAMOS WS-SALDO-ORIGEN.    
                                                                 
           IF WS-ERROR = "N"                                     
                                                                 
             EXEC SQL                                            
              SELECT SALDO                                       
              INTO :WS-SALDO-ORIGEN                              
              FROM CUENTAS                                       
             WHERE ID_CUENTA = :WP-TRANSFE2                      
             END-EXEC                                            
                                                                 
           IF SQLCODE NOT = 0                                    
            DISPLAY "ERROR CONSULTANDO SALDO ORIGEN"             
            MOVE "S" TO WS-ERROR                                 
          ELSE                                                   
           IF WS-SALDO-ORIGEN < WP-TRANSFE4                      
              DISPLAY "ERROR: SALDO INSUFICIENTE"                
              DISPLAY "SALDO: " WS-SALDO-ORIGEN                  
              DISPLAY "IMPORTE: " WP-TRANSFE4                    
              MOVE "S" TO WS-ERROR                               
           END-IF                                                
           END-IF                                                
                                                                 
           END-IF.                                               
  *---------------------------------------                       
  * COMPROBAR QUE NO SEA LA MISMA CUENTA                         
  *----------------------------------------                      
                                                                 
          IF WS-ERROR = "N"                                      
             IF WP-TRANSFE2 = WP-TRANSFE3                        
                 DISPLAY "ERROR: ORIGEN Y DESTINO IGUALES"       
                  MOVE "S" TO WS-ERROR  
                   END-IF                                          
               END-IF.                                             
    *-----------------------------------------------------------   
    * SI HAY ERROR, DEJAMOS LA TRANSFERENCIA EN P                  
    *-----------------------------------------------------------   
               IF WS-ERROR = "S"                                   
                   DISPLAY "TRANSFERENCIA NO PROCESADA"            
               END-IF.                                             
    *-----------------------------------------------------------   
    * ACTUALIZAR CUENTA ORIGEN                                     
    *-----------------------------------------------------------   
               COMPUTE WS-SALDO-ORIGEN =                           
                       WS-SALDO-ORIGEN - WP-TRANSFE4.              
               EXEC SQL                                            
                   UPDATE CUENTAS                                  
                      SET SALDO = :WS-SALDO-ORIGEN                 
                   WHERE ID_CUENTA = :WP-TRANSFE2                  
                END-EXEC.                                          
                IF SQLCODE NOT = 0                                 
                  DISPLAY "ERROR ACTUALIZANDO CUENTA ORIGEN"       
                  EXEC SQL                                         
                      ROLLBACK                                     
                  END-EXEC                                         
                  MOVE "S" TO WS-ERROR                             
                  END-IF.                                          
    *--------------------------------------------------------------
    * ACTUALIZAR CUENTA DESTINO                                    
    *---------------------------------------------------------     
                 EXEC SQL                                          
                     UPDATE CUENTAS                                
                        SET SALDO = SALDO + :WP-TRANSFE4           
                      WHERE ID_CUENTA = :WP-TRANSFE3               
                 END-EXEC.                                         
                 IF SQLCODE NOT = 0                                
                     DISPLAY "ERROR ACTUALIZANDO CUENTA DESTINO"   
                     EXEC SQL                                      
                         ROLLBACK                                  
                     END-EXEC                                      
                     MOVE "S" TO WS-ERROR 
                  END-IF.                                              
    *----------------------------------------------------------       
    * OBTENER ID PARA MOVIMIENTO DE SALIDA                            
    *----------------------------------------------------------       
                EXEC SQL                                              
                    SELECT COALESCE(MAX(ID_MOVIMIENTO),0) + 1         
                      INTO :WS-NUEVO-ID-MOV                           
                      FROM MOVIMIENTOS                                
                END-EXEC.                                             
              IF SQLCODE NOT = 0                                      
                  EXEC SQL                                            
                      ROLLBACK                                        
                  END-EXEC                                            
                  MOVE "S" TO WS-ERROR                                
                  END-IF.                                             
    *---------------------------------------------------------------  
    * MOVIMIENTO DE SALIDA                                            
    *----------------------------------------------------------       
                MOVE WS-NUEVO-ID-MOV TO WS-MOVI1.                     
                MOVE WP-TRANSFE1     TO WS-MOVI2.                     
                MOVE WP-TRANSFE2     TO WS-MOVI3.                     
                MOVE "S"             TO WS-MOVI4.                     
                MOVE WP-TRANSFE4     TO WS-MOVI5.                     
                MOVE WP-TRANSFE5     TO WS-MOVI6.                     
                EXEC SQL                                              
                    INSERT INTO MOVIMIENTOS                           
                        (ID_MOVIMIENTO,                               
                         ID_TRANSFERENCIA,                            
                         ID_CUENTA,                                   
                         TIPO_MOV,                                    
                         IMPORTE,                                     
                         FECHA_MOV)                                   
                    VALUES                                            
                        (:WS-MOVI1,                                   
                         :WS-MOVI2,                                   
                         :WS-MOVI3,                                   
                         :WS-MOVI4,                                   
                         :WS-MOVI5,                                   
                         :WS-MOVI6)    
                END-EXEC.                                            
               IF SQLCODE NOT = 0                                   
                  DISPLAY "ERROR INSERTANDO MOVIMIENTO DE SALIDA"   
                  EXEC SQL                                          
                      ROLLBACK                                      
                  END-EXEC                                          
                  MOVE "S" TO WS-ERROR                              
               END-IF.                                              
   *----------------------------------------                        
   * SIGUIENTE ID MOVIMIENTO                                        
   *---------------------------------------                         
            ADD 1 TO WS-NUEVO-ID-MOV.                               
   *------------------------------------                            
   * MOVIMIENTO DE ENTRADA                                          
   *-----------------------------------                             
               MOVE WS-NUEVO-ID-MOV TO WS-MOVI1.                    
               MOVE WP-TRANSFE1  TO WS-MOVI2.                       
               MOVE WP-TRANSFE3  TO WS-MOVI3.                       
               MOVE "E"    TO WS-MOVI4                              
               MOVE WP-TRANSFE4 TO WS-MOVI5.                        
               MOVE WP-TRANSFE5 TO WS-MOVI6.                        
                                                                    
               EXEC SQL                                             
                   INSERT INTO MOVIMIENTOS                          
                    ( ID_MOVIMIENTO,                                
                      ID_TRANSFERENCIA,                             
                      ID_CUENTA,                                    
                      TIPO_MOV,                                     
                      IMPORTE,                                      
                      FECHA_MOV )                                   
                   VALUES                                           
                     ( :WS-MOVI1,                                   
                       :WS-MOVI2,                                   
                       :WS-MOVI3,                                   
                       :WS-MOVI4,                                   
                       :WS-MOVI5,                                   
                       :WS-MOVI6 )                                  
               END-EXEC.                                            
               IF SQLCODE NOT = 0   
                  DISPLAY "ERROR INSERTANDO MOVIMIENTO ENTRADA"     
                                                                    
                  EXEC SQL                                          
                      ROLLBACK                                      
                  END-EXEC                                          
                  MOVE "S" TO WS-ERROR                              
                  END-IF.                                           
   *------------------------------------------------------------    
   * PASAR TRANSFERENCIA DE P A R                                   
   *------------------------------------------------------------    
             EXEC SQL                                               
                 UPDATE TRANSFERENCIAS                              
                    SET ESTADO ="R"                                 
                  WHERE ID_TRANSFERENCIA = :WP-TRANSFE1             
             END-EXEC.                                              
                                                                    
             IF SQLCODE NOT = 0                                     
                 DISPLAY "ERROR ACTUALIZANDO TRANSFERENCIA"         
                 EXEC SQL                                           
                     ROLLBACK                                       
                 END-EXEC                                           
                 MOVE "S" TO WS-ERROR                               
             END-IF.                                                
   *------------------------------------------------------------    
   * CONFIRMAR TODO                                                 
   *------------------------------------------------------------    
             EXEC SQL                                               
              COMMIT                                                
             END-EXEC.                                              
                                                                    
             IF SQLCODE = 0                                         
                ADD 1 TO WS-CONTADOR                                
                DISPLAY "TRANSFERENCIA " WP-TRANSFE1                
                DISPLAY " REALIZADA CORRECTAMENTE"                  
             ELSE                                                   
                DISPLAY " ERROR EN COMMIT. SQLCODE=" SQLCODE        
              EXEC SQL                                              
                  ROLLBACK                                          
              END-EXEC   
               MOVE "S" TO WS-ERROR            
            END-IF.                                                                                                                                                                                                                                     
