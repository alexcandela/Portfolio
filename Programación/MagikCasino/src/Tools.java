import java.util.Scanner;

public interface Tools {

    public static void limpiarPantalla() {
        try {
            if (System.getProperty("os.name").contains("Windows")) {
                new ProcessBuilder("cmd", "/c", "cls").inheritIO().start().waitFor();
            } else {
                new ProcessBuilder("clear").inheritIO().start().waitFor();
            }
        } catch (Exception e) {
            // Manejo de excepciones
            e.printStackTrace();
        }
    }

    public static boolean controlErrores(String valor) {
        try {
            int numero = Integer.parseInt(valor);
            if (numero < 0) {
                return false;
            } else {
                return true;
            }
        } catch (NumberFormatException e) {
            return false;
        }
    }
}
