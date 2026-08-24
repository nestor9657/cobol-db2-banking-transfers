//TRANS02  JOB (IBMUSER),'TRANS02',                                     
//             CLASS=A,                                                 
//             MSGCLASS=H,                                              
//             MSGLEVEL=(1,1),                                          
//             NOTIFY=&SYSUID                                           
//*                                                                     
//COMPILA  EXEC DSNHICOB,USER=IBMUSER.NESTOR,MEM=TRANS02                
//*                                                                     
//PC.SYSIN DD DSN=IBMUSER.NESTOR.FUENTES(TRANS02),DISP=SHR              
//PCSYSLIB DD DSN=IBMUSER.DB2.DCLGEN,DISP=SHR                           
//*----------------------------------------------------------------*    
//*                    DB2 BIND PLAN                               *    
//*----------------------------------------------------------------*    
//BINDPL   EXEC PGM=IKJEFT01,REGION=8M                                  
//STEPLIB  DD DSN=DSN910.SDSNLOAD,DISP=SHR                              
//DBRMLIB  DD DISP=SHR,DSN=IBMUSER.NESTOR.DBRMLIB.DATA(TRANS02)         
//SYSPRINT DD SYSOUT=A                                                  
//SYSTSPRT DD SYSOUT=A                                                  
//SYSTSIN  DD DSN=IBMUSER.NESTOR.BIND(TRANS02),DISP=SHR                 
