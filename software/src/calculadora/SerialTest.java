/* Extraído do link
 * http://playground.arduino.cc/Interfacing/Java
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package calculadora;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import gnu.io.CommPortIdentifier;
import gnu.io.SerialPort;
import gnu.io.SerialPortEvent;
import gnu.io.SerialPortEventListener;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class SerialTest implements SerialPortEventListener {
   /**
    * The port we're normally going to use.
    
   private static final String PORT_NAMES[] = {
      "/dev/tty.usbserial-A9007UX1", // Mac OS X
      "/dev/ttyACM0", // Raspberry Pi
      "/dev/ttyUSB0", // Linux
      "COM3", // Windows
   };*/
   
   private SerialPort serialPort;

   public SerialPort getSerialPort() {
      return serialPort;
   }

   /**
    * A BufferedReader which will be fed by a InputStreamReader converting the
    * bytes into characters making the displayed results codepage independent
    */
   private BufferedReader input;
   /**
    * The output stream to the port
    */
   private OutputStream out;
   /**
    * Milliseconds to block while waiting for port open
    */
   private static final int TIME_OUT = 2000;
   /**
    * Default bits per second for COM port.
    */
   private static final int DATA_RATE = 9600;

   List<CommPortIdentifier> listadeportas = new ArrayList();
   
   public SerialTest() { 
   }

   public String[] retornaPortas() {
      Enumeration<CommPortIdentifier> numPorta = CommPortIdentifier.getPortIdentifiers();
      if (!numPorta.hasMoreElements()) {
         return null;
      }
      
      String nomes = "";
      while (numPorta.hasMoreElements()) {
         CommPortIdentifier idporta = numPorta.nextElement();
         listadeportas.add(idporta);
         if (idporta.getPortType() == 1) {
            nomes = nomes.concat(idporta.getName() + " - SERIAL;");
         }
         if (idporta.getPortType() == 2) {
            nomes = nomes.concat(idporta.getName() + " - PARALELA;");
         }
      }
      String[] ports;
      ports = nomes.split(";");
      return ports;
   }

   public void initialize(String nomedaporta) {
      // the next line is for Raspberry Pi and 
      // gets us into the while loop and was suggested here was suggested http://www.raspberrypi.org/phpBB3/viewtopic.php?f=81&t=32186
      System.setProperty("gnu.io.rxtx.SerialPorts", "/dev/ttyACM0");
       CommPortIdentifier portId = null;
      for (CommPortIdentifier currPortId : listadeportas) {
         //System.out.println(currPortId.getName()+" - "+nomedaporta);
      if (currPortId.getName().equals(nomedaporta)) {
         portId = currPortId;
         break;
      }

      }
      if (portId == null) {
         javax.swing.JOptionPane.showMessageDialog(null, "Não foi possível abrir a porta selecionada!", "Atenção!", 2);
         return;
      }
      try {
         // open serial port, and use class name for the appName.
         serialPort = (SerialPort) portId.open(this.getClass().getName(),
                 TIME_OUT);

         // set port parameters
         serialPort.setSerialPortParams(DATA_RATE,
                 SerialPort.DATABITS_8,
                 SerialPort.STOPBITS_1,
                 SerialPort.PARITY_NONE);
         serialPort.setFlowControlMode(SerialPort.FLOWCONTROL_NONE); //modif
         // open the streams
         input = new BufferedReader(new InputStreamReader(serialPort.getInputStream()));
         out = serialPort.getOutputStream();

         // add event listeners
         serialPort.addEventListener(this);
         serialPort.notifyOnDataAvailable(true);
      } catch (Exception e) {
         javax.swing.JOptionPane.showMessageDialog(null, "Erro abrindo comunicação: "+e.toString(), "Atenção!", 2);
         return;
      }
      javax.swing.JOptionPane.showMessageDialog(null, "Porta Iniciada Com Sucesso!", "OK!", 1);
   }
    

   /**
    * This should be called when you stop using the port. This will prevent port
    * locking on platforms like Linux.
    */
   public synchronized void close() {
      if (serialPort != null) {
         serialPort.removeEventListener();
         serialPort.close();
      }
   }

   /**
    * Handle an event on the serial port. Read the data and print it.
    */
   @Override
   public synchronized void serialEvent(SerialPortEvent oEvent) {
      if (oEvent.getEventType() == SerialPortEvent.DATA_AVAILABLE) {
         try {
            String inputLine = input.readLine();
            System.out.println(inputLine);
         } catch (Exception e) {
            System.err.println(e.toString());
         }
      }
      // Ignore all the other eventTypes, but you should consider the other ones.
   }
   
    public void escrevernaPorta(String str)
        {
                try
                {
                  /* byte[] bytes = str.getBytes();
                   System.out.println("Quant"+bytes.length);
                  for(int k=0;k<bytes.length;k++){
                   
                      System.out.println(bytes[k]+"-");
                   }
                    */
                   this.out.write(str.getBytes());
                        this.out.flush();
                }
                catch (IOException e)
                {
                        e.printStackTrace();
                }
        }
    
    public void escrevervetor(byte b[]){
      try {
         this.out.write(b);
         this.out.flush();
      } catch (IOException ex) {
         ex.printStackTrace();
      }
    }
    
}