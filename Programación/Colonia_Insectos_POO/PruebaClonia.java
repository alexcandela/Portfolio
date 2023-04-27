package UF4A5_Colonia_Insectos;
import java.util.Scanner;

import javax.sound.midi.Soundbank;

public class PruebaClonia {
    public static void main(String[] args) {
        Scanner in = new Scanner(System.in);
        String tipo;
        int obreras, reinas, comida;
        
        System.out.print("Indica el tipo de colonia (Hormigas/Abejas): ");
        tipo = in.nextLine().toLowerCase();
        System.out.print("Indica el número de obreras: ");
        obreras = in.nextInt();
        System.out.print("Indica el número de reinas: ");
        reinas = in.nextInt();
        System.out.print("Indica cuanta comida tendrá la colonia: ");
        comida = in.nextInt();
        Colonia c1 = new Colonia(tipo, obreras, reinas, comida);
               
            c1.recolectar();
        for (int i = 0; i < 3; i++) {
            System.out.println("Turno --> " + i);
            
            c1.comer();
        }
    }
}
