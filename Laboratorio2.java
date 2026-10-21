/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Main.java to edit this template
 */
package laboratorio2;

import java.util.Scanner;
import javax.swing.ImageIcon;
import javax.swing.JLabel;
import javax.swing.JOptionPane;

/**
 *
 * @author santi
 */
public class Laboratorio2 {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        // Hecho por Santiago Ortega, Juan Pacheco, Javier Torregrosa, Samantha Pertuz

        Scanner lec = new Scanner(System.in);
        int menu = 0, interaccion = 0, n = 0, i = 1, confirmacion = 0, Verificacion = 1, V2 = 0, v3 = 0;
        double sumaintep = 0, sumainten = 0, sumatotinte;
        String userOR, UserDes, estado = "";
        
        ImageIcon icon = new ImageIcon("images/cinematica1.PNG");
        JOptionPane.showMessageDialog(null, "", "", menu, icon);
        
        icon = new ImageIcon("images/cinematica2.PNG");
        JOptionPane.showMessageDialog(null, "", "", menu, icon);
        
        icon = new ImageIcon("images/cinematica3.PNG");
        JOptionPane.showMessageDialog(null, "", "", menu, icon);
        
        icon = new ImageIcon("images/cinematica4.PNG");
        JOptionPane.showMessageDialog(null, "", "", menu, icon);
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
// azul
        try {
            do {
                do{
                    v3 = 0;
                try {
                    
                    icon = new ImageIcon("images/Menu2.JPG");
                    String input = (String) JOptionPane.showInputDialog(null, estado, estado, JOptionPane.PLAIN_MESSAGE, icon, null, null);
                    menu = Integer.parseInt(input);
                    
//            System.out.println("=== MENU PRINCIPAL ===");
//            System.out.println("1. Registrar interaccion");
//            System.out.println("2. Analizar Comportamiento");
//            System.out.println("3. Simular propagacion del acoso");
//            System.out.println("4. Escoge el camino");
//            System.out.println("5. Ver Reputacion");
//            System.out.println("6. Salir ");
//            System.out.println(" Seleccione una opccion: ");
//            menu = lec.nextInt();
                         } catch (Exception e) {
                            System.out.println("");
                            icon = new ImageIcon("images/miles.PNG");
                            JOptionPane.showMessageDialog(null, "Debes escribir un numero", "Advertencia Error", menu, icon);
                            
                            v3 = 1;
                         }
                     } while (v3 == 1);
            

            switch (menu) {
                case 1:
                    do {
                        
                        icon = new ImageIcon("images/usuarioO.JPG");
                        String input = (String) JOptionPane.showInputDialog(null, estado, estado, JOptionPane.PLAIN_MESSAGE, icon, null, null);
                        
//                        System.out.println("                   ");
//                        System.out.println("Ingrese el origen del usuario (preferiblemente un nombre)");
//                        lec.nextLine();
//                        userOR = lec.nextLine();   
                    
                    icon = new ImageIcon("images/afectado.JPG");
                    input = (String) JOptionPane.showInputDialog(null, estado, estado, JOptionPane.PLAIN_MESSAGE, icon, null, null);

//                    System.out.println("   ");
//                    System.out.println("Ingrese el Usurio destino");
//                    UserDes = lec.nextLine();
                        do {
                            v3 = 0;
                            try {
                                
                                icon = new ImageIcon("images/sehuro.JPG");
                            input = (String) JOptionPane.showInputDialog(null, estado, estado, JOptionPane.PLAIN_MESSAGE, icon, null, null);
                    confirmacion = Integer.parseInt(input);
                                
                                
//                            System.out.println("Estas Seguro de tus respuestas? (1) si, (0) no");
//                        confirmacion = lec.nextInt();

                        } catch (Exception e) {
                            System.out.println("Debes escribir un numero, Si el numero es diferente, se considera la respuesta como (NO)");
//                            lec.nextLine();
                            v3 = 1;
                        }
                        } while (v3 == 1);
                        
                        
                    } while(confirmacion != 1);
                    
                    do {
                        V2 = 0;
                        try {
                            
                            icon = new ImageIcon("images/interaccionesn.JPG");
                            
                    String input = (String) JOptionPane.showInputDialog(null, estado, estado, JOptionPane.PLAIN_MESSAGE, icon, null, null);
                    
                    n = Integer.parseInt(input);
                    
                        System.out.println("Ingre" + "se la cantidad de interacciones que desea registrar");
                        
//                    n = lec.nextInt();

                    } catch (Exception e) {
                            System.out.println("");
                            icon = new ImageIcon("images/miles.PNG");
                            
                            JOptionPane.showMessageDialog(null, "Debes escribir un numero", "Advertencia Error", menu, icon);
                            System.out.println("Debes ingresar un numero");
                            V2 = 1;
                    }
                    } while (V2 == 1);
                    
                    
                    
                    // Interacciones para registrar
                    Verificacion = 1;
                    while (Verificacion == 1){
                      Verificacion = 0; 
                       try {
                        for (i = 1; i <= n; i++) {
                        do {
                            
                            // Do usado para verificar que sea el numero 1 o el numero 2
                            
                            icon = new ImageIcon("images/interaccion12.JPG");
                            String input = (String) JOptionPane.showInputDialog(null, estado, estado, JOptionPane.PLAIN_MESSAGE, icon, null, null);
                    interaccion = Integer.parseInt(input);
                            
//                            System.out.println("                          ");
//                            System.out.println("--------------------------");
//                            System.out.println("Ingrese el tipo de interaccion (1) positiva (2) negativa");
//                            interaccion = lec.nextInt();
                            
                            if (interaccion == 1){
                                
                                int p;
                                
                                icon = new ImageIcon("images/mensajesN.JPG");
                            input = (String) JOptionPane.showInputDialog(null, estado, estado, JOptionPane.PLAIN_MESSAGE, icon, null, null);
                    p = Integer.parseInt(input);
                                
                                sumaintep+= 1;
                            } else if (interaccion == 2){
                                
                                int p;
                                
                                icon = new ImageIcon("images/mensajesP.JPG");
                            input = (String) JOptionPane.showInputDialog(null, estado, estado, JOptionPane.PLAIN_MESSAGE, icon, null, null);
                    p = Integer.parseInt(input);
                                
                                
                                sumainten+= 1;
                            } else {
                                System.out.println("Debe Ingresar (1) o (2)");
                            }
                        } while (interaccion != 1 && interaccion != 2);
                    }
                    } catch (Exception e) {
                        
                        icon = new ImageIcon("images/miles.PNG");
                            JOptionPane.showMessageDialog(null, "Debes escribir un numero, Ingrese de nuevo todas tus interacciones", "Advertencia Error", menu, icon);
                        
                        System.out.println("Debe escribir un Numero, tendras que poner las interacciones nuevamente");
                        Verificacion = 1;
                    }   
                    }
                        
                    
                    

                    
                    break;
                case 2:
                    
                    System.out.println(" ");
                    System.out.println("Tu numero de interacciones Positivas son: " + sumaintep);
                    System.out.println("Tu numero de interacciones negativas son: " + sumainten);
                    
                    if (sumainten > sumaintep ){
                        estado = "USUARIO EN RIESGO!!";
                        icon = new ImageIcon("images/peligro.JPG");
        JOptionPane.showMessageDialog(null, "Intro", "", menu, icon);
        
                    } else if (sumaintep >= sumainten){
                        
                        icon = new ImageIcon("images/Estable.JPG");
        JOptionPane.showMessageDialog(null, "Intro", "", menu, icon);
                        
                        estado = "Usuario estable";
                    }
                    
                    
                    System.out.println("Tu estados es: " + estado);
                    System.out.println(" ");
                    break;
                case 3:
                     // Simulacion de acoso, mas el try
                    do{ // inicio del do-while
                        V2 = 0;
                        try {
                            
                            
                            
//                    System.out.println("\n===== SIMULACION DE PROPAGACION =====");
//                    System.out.print("Cuantos niveles deseas simular? (recomendado: 5): ");
                    int niveles;
//                    lec.nextLine();


                    icon = new ImageIcon("images/simulacion.JPG");
                            String input = (String) JOptionPane.showInputDialog(null, estado, estado, JOptionPane.PLAIN_MESSAGE, icon, null, null);
                    niveles = Integer.parseInt(input);

                    if (niveles < 1) {
                        System.out.println("Debe ser al menos 1 nivel.");
                    } else {
                        int afectados = 1;
                        int totalAfectados = 0;

                        System.out.println("\nNivel\tUsuarios afectados");
                        System.out.println("-------------------------");

                        for (int nivel = 1; nivel <= niveles; nivel++) {
                            afectados = afectados * 2;                      //formula para los infectado
                            totalAfectados += afectados;
                            System.out.println("  " + nivel + "\t" + afectados + " usuarios afectados");
                        }
                        
                        if (niveles <= 10){
                            ImageIcon gif = new ImageIcon("videos/Video1r.GIF");

        JLabel label = new JLabel(gif);

        JOptionPane.showMessageDialog(null,label,"Cinemática",JOptionPane.PLAIN_MESSAGE);
        
        icon = new ImageIcon("images/tienestiempo.JPG");
        JOptionPane.showMessageDialog(null, "", "", menu, icon);
        
                        } else if (niveles > 10 && niveles <= 20){
                            ImageIcon gif = new ImageIcon("videos/Video3r.GIF");

        JLabel label = new JLabel(gif);

        JOptionPane.showMessageDialog(null,label,"Cinemática",JOptionPane.PLAIN_MESSAGE);
        
        icon = new ImageIcon("images/pocotiempo.JPG");
        JOptionPane.showMessageDialog(null, "", "", menu, icon);
        
                        } else if (niveles > 20){
                            ImageIcon gif = new ImageIcon("videos/Video2r.GIF");

        JLabel label = new JLabel(gif);

        JOptionPane.showMessageDialog(null,label,"Cinemática",JOptionPane.PLAIN_MESSAGE);
        
        
        icon = new ImageIcon("images/todoslosaben"
                + ".JPG");
        JOptionPane.showMessageDialog(null, "", "", menu, icon);
        
                        }

                        System.out.println("-------------------------");
                        System.out.println("Total acumulado: " + totalAfectados + " usuarios afectados.");
                        System.out.println("El acoso se expande muy rapido. Actua a tiempo!");
                    }
                        } catch (Exception e) {
                            System.out.println("Debe ingresar un numero");
                            lec.nextLine();
                            V2 = 1;
                        }
                    } while (V2 == 1); // fin del do-while
                    
                    break;
                case 4:
                    do {
                        V2 = 0;
                        try {
                            int decision = 0; // definir variable
                            
                            icon = new ImageIcon("images/imagen3.JPG");
                    String input = (String) JOptionPane.showInputDialog(null, estado, estado, JOptionPane.PLAIN_MESSAGE, icon, null, null);
                    decision = Integer.parseInt(input);
                    
//                            System.out.println("\n===== TOMAR DECISIONES =====");
//                    System.out.println("Un usuario esta siendo acosado. Que deseas hacer?");
//                    System.out.println("1. SILENCI  O 🕊️");
//                    System.out.println("2. EXPONER (╯°□°）╯︵ ┻━┻");
//                    System.out.println("3. BLOQUEAR");
//                    System.out.println("4. AYUDAR");
//                    System.out.print("Tu decision: ");
//
//                    decision = lec.nextInt();
//                    lec.nextLine();

                    switch (decision) {

                        case 1:
                            
                            icon = new ImageIcon("images/ignorar.PNG");
        JOptionPane.showMessageDialog(null, "", "", JOptionPane.PLAIN_MESSAGE, icon);
                            
                            
//                            System.out.println("\nDecidiste: IGNORAR");
//                            System.out.println("Resultado: La situacion empeora.");
//                            System.out.println("El acoso continua y la victima se siente sola.");
//                            System.out.println("Ignorar tambien es una forma de permitirlo.");
                            break;
                            
                        case 2:
                            int reporte;
                            icon = new ImageIcon("images/reportar.JPG");
                    input = (String) JOptionPane.showInputDialog(null, estado, estado, JOptionPane.PLAIN_MESSAGE, icon, null, null);
                    reporte = Integer.parseInt(input);
                            
//                            System.out.println("\nDecidiste: REPORTAR");
//                            System.out.println("Resultado: La situacion mejora.");
//                            System.out.println("A quien reportaste?");
//                            System.out.println("  1. A un docente");
//                            System.out.println("  2. A la plataforma");
//                            System.out.print("Seleccione: ");
//
//                            reporte = lec.nextInt();
//                            lec.nextLine();

                            switch (reporte) {
                                case 1:
                                    System.out.println("Excelente. El docente puede intervenir directamente.");
                                    
                                    icon = new ImageIcon("images/caso1.PNG");
        JOptionPane.showMessageDialog(null, "", "", JOptionPane.PLAIN_MESSAGE, icon);
                                    
                                    break;
                                case 2:
                                    System.out.println("Bien hecho. La plataforma puede bloquear al agresor.");
                                    
                                    icon = new ImageIcon("images/caso2.PNG");
        JOptionPane.showMessageDialog(null, "", "", JOptionPane.PLAIN_MESSAGE, icon);
                                    
                                    break;
                                default:
                                    System.out.println("Opcion no reconocida, pero reportar siempre ayuda.");
                                    
                                    icon = new ImageIcon("images/caso3.PNG");
        JOptionPane.showMessageDialog(null, "", "", JOptionPane.PLAIN_MESSAGE, icon);
                                    
                                    break;
                            }
                            break;

                        case 3:
                            
                            icon = new ImageIcon("images/bloquear.PNG");
        JOptionPane.showMessageDialog(null, "", "", JOptionPane.PLAIN_MESSAGE, icon);
                            
                            
                            
//                            System.out.println("\nDecidiste: BLOQUEAR");
//                            System.out.println("Resultado: Se reduce el impacto del acoso.");
//                            System.out.println("El agresor ya no puede contactar a la victima directamente.");
//                            System.out.println("Combinar con un reporte hace mas diferencia.");
                            break;

                        case 4:
                            
                            icon = new ImageIcon("images/apoyar.PNG");
        JOptionPane.showMessageDialog(null, "", "", JOptionPane.PLAIN_MESSAGE, icon);
                            
                            
//                            System.out.println("\nDecidiste: APOYAR");
//                            System.out.println("Resultado: La situacion mejora significativamente!");
//                            System.out.println("La victima se siente acompanada y con mas fuerza.");
//                            System.out.println("Eres parte del cambio! Apoyar salva vidas.");
                            break;
                        case 5:
                            System.out.println("\nHasta luego! Recuerda actuar siempre con respeto.");
                            break;
                        default:
                            System.out.println("Opcion no valida. Por favor elige entre 1 y 4.");
                            break;
                    }
                        } catch (Exception e) {
                           
                            icon = new ImageIcon("images/miles.PNG");
        JOptionPane.showMessageDialog(null, "Debes escribir un numero", "Debes escribir un numero", JOptionPane.INFORMATION_MESSAGE, icon);
            
                            //System.out.println("Debes ingresar un numero!!");
                            
                            V2 = 1;
                        }
                        
                    } while (V2 == 1);
                    
                case 5:
                    
                    // Reputacion 
                    sumatotinte = sumaintep + sumainten; // suma de las interacciones positivas y las negativas
                    System.out.println("              ");
                    if (sumatotinte >= 1){
                        
                        System.out.println("El total de interacciones durante tu estancia fueron " + sumatotinte);
                        
                        
                    double porcent = ((sumainten/sumatotinte)*100);   // Esto es para porcentaje final
                    if (porcent > 70){
                        
                        System.out.println("Tu reputacion esta mancha, nadie te respeta!!");
                        
                        
                       icon = new ImageIcon("images/manchada.JPG");
        JOptionPane.showMessageDialog(null, "", "", JOptionPane.PLAIN_MESSAGE, icon);
            
            
                        System.out.println("Tu reputacion esta en peligro, pocos confian en ti");
                        
                    } else if (porcent >= 40 && porcent <= 70) {
                        
                        icon = new ImageIcon("images/confian.JPG");
        JOptionPane.showMessageDialog(null, "", "", JOptionPane.PLAIN_MESSAGE, icon);
        
                        System.out.println("Tu reputacion esta en peligro, pocos confian en ti");
                    } else {
                        System.out.println("Tu reputacion es buena, Mantenla limpia");
                        
                        icon = new ImageIcon("images/buenarep"
                                + ".JPG");
        JOptionPane.showMessageDialog(null, "", "", JOptionPane.PLAIN_MESSAGE, icon);
                        
                    }
                    } else{
                        System.out.println("No tiene interacciones registradas por el momento");
                    }
                    
                    break;
                default:
                    System.out.println("Saliste del menu");
            }

        } while (menu != 6);
            
            icon = new ImageIcon("images/final.JPG");
        JOptionPane.showMessageDialog(null, "", "", JOptionPane.PLAIN_MESSAGE, icon);
            
        } catch (Exception e) {
            System.out.println("Ocurrio un error");
            icon = new ImageIcon("miles.PNG");
            
            JOptionPane.showMessageDialog(null, "Debes escribir un numero", "Advertencia Error", JOptionPane.PLAIN_MESSAGE, icon);
        }

    }

}
