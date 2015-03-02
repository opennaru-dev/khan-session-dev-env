startEdit()

cd('/Servers/Weblogic_Test_Server')
cmo.setListenAddress('1.1.1.1')

cd('/Servers/Weblogic_Test_Server/SSL/Weblogic_Test_Server')
cmo.setEnabled(false)

activate()

startEdit()

