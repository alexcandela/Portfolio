import java.util.Scanner;

public class MagikCasino implements Tools{
    static Scanner in = new Scanner(System.in);

    public static void main(String[] args) throws Exception {
        Tools.limpiarPantalla();
        int opMenuInicio = -1;
        do {
            System.out.println("---¡BIENVENIDO A MAGIK CASINO!---");
            System.out.println("1 -- POKER");
            System.out.println("2 -- BLACK JACK");
            System.out.println("3 -- RULETA");
            System.out.println("0 -- SALIR");

            if (in.hasNextInt()) {
                opMenuInicio = in.nextInt();
                switch (opMenuInicio) {
                    case 1:
                        Tools.limpiarPantalla();
                        poker();
                        break;
                    case 2:
                        Tools.limpiarPantalla();
                        System.out.println("BLACK JACK no disponible. Lo sentimos.");
                        System.out.println();
                        break;
                    case 3:
                        Tools.limpiarPantalla();
                        System.out.println("RULETA no disponible. Lo sentimos.");
                        System.out.println();
                        break;
                    case 0:
                        System.out.println("Saliendo...");
                        break;
                    default:
                        Tools.limpiarPantalla();
                        System.out.println("Opción no valida!");
                        System.out.println();
                }
            } else {
                Tools.limpiarPantalla();
                System.out.println("Error. Escribe un numero.");
                System.out.println();
                in.next();
            }
        } while (opMenuInicio != 0);

    }

    

    public static void poker() {
        int opMenuPoker = -1;
        System.out.println("---¡[POKER] MAGIK!---");
        do {
            System.out.println("1 -- Iniciar partida");
            System.out.println("0 -- Volver al menú principal");

            if (in.hasNextInt()) {
                opMenuPoker = in.nextInt();
                switch (opMenuPoker) {
                    case 1:
                        Tools.limpiarPantalla();
                        Poker p1 = new Poker();
                        p1.iniciarPartida();
                        break;
                    case 0:
                        Tools.limpiarPantalla();
                        System.out.println("Volviendo al menú principal");
                        break;
                    default:
                        System.out.println("Opción no valida!");
                }
            } else {
                System.out.println("Error. Escribe un numero.");
                in.next();
            }
        } while (opMenuPoker != 0);

    }
}
