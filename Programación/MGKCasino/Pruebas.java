import java.util.Scanner;

public class Pruebas implements Tools {
    public static void main(String[] args) {
        Scanner in = new Scanner(System.in);
        System.out.println("Escribe:");
        String op = in.nextLine();
        if (Tools.controlErrores(op)) {
            System.out.println("Opcion valida");
        } else {
            System.out.println("Opcion no valida");
        }
    }
}

