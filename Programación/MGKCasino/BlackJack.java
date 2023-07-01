import java.util.Scanner;

public class BlackJack {
    Jugador j1 = new Jugador(100);
    Jugador ia = new Jugador(100);
    Baraja b;
    static int cantEnJuego;
    static boolean retirarse = false;
    static boolean volverAtras = false;

    public BlackJack() {

    }

    public void iniciarPartida() {
        do {
            
            partida();
        } while (j1.dinero > 0 && ia.dinero > 0);
        if (ia.dinero <= 0) {
            System.out.println("¡Has ganado la partida!");
        } else if (j1.dinero <= 0) {
            System.out.println("¡Has perdido!");
        }
    }
    static Scanner in = new Scanner(System.in);
    public void partida(){
        cantEnJuego = 0;
        
        b = new Baraja();
        boolean ultimoTurno = false;
        j1.recibirCartas(b.repartirCartas());
        ia.recibirCartas(b.repartirCartas());

        System.out.println("------------------------------------------------------------------------");
                System.out.println("Tu Dinero: " + j1.dinero + " MagiKoins");
                System.out.print("Tus cartas - ");
                j1.mostrarCartas();
                
                System.out.println();
                System.out.println("MagiKoins en juego " + cantEnJuego);
                System.out.println();
                in.nextLine();
    }
}
