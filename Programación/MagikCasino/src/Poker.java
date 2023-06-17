import java.util.Scanner;

public class Poker {

    Jugador j1 = new Jugador(100);
    Jugador ia = new Jugador(100);
    String mesa[] = new String[5];
    Baraja b;
    static int cantEnJuego;
    static boolean retirarse = false;
    static boolean volverAtras = false;

    public Poker() {

    }

    static Scanner in = new Scanner(System.in);

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

    public void partida() {
        cantEnJuego = 0;
        b = new Baraja();
        boolean ultimoTurno = false;
        j1.recibirCartas(b.repartirCartas());
        ia.recibirCartas(b.repartirCartas());

        mesa = b.repartirCartasMesa(mesa);

        do {
            cantEnJuego = 0;
            for (int i = 0; i < 3; i++) {
                retirarse = false;
                if (volverAtras == true) {
                    i -= 1;
                    if (i <= 0) {
                        i = 0;
                    }
                }
                volverAtras = false;
                System.out.println("------------------------------------------------------------------------");
                System.out.println("Tu Dinero: " + j1.dinero + " MagiKoins");
                System.out.println();
                System.out.print("Tus cartas - ");
                j1.mostrarCartas();
                System.out.println();
                System.out.println("MagiKoins en juego " + cantEnJuego);
                System.out.println("Truno " + (i + 1));
                System.out.print("[Mesa] - ");
                b.mostrarMesa(mesa, (i + 1));
                System.out.println();
                System.out.println("| 1 - Seguir | 2 - Apostar | 3 - Retirarse |");
                apostarSeguirRet(j1);
                System.out.println("MagiKoins en juego " + cantEnJuego);
                System.out.println();

                if (retirarse == true) {
                    break;
                }

                if (i == 2) {
                    System.out.print("[Tus cartas] - ");
                    j1.mostrarCartas();
                    System.out.println();
                    System.out.print("[Cartas IA] - ");
                    ia.mostrarCartas();
                    if ((ganadorPareja(
                            pareja(mesa, j1.getCartas())) > (ganadorPareja(pareja(mesa, ia.getCartas()))))) {
                        System.out.println("Jugador 1 gana por " + pareja(mesa, j1.getCartas()));
                        darMagiKoins(j1, cantEnJuego);
                        ultimoTurno = true;
                        in.nextLine();
                        
                        
                    } else if ((ganadorPareja(
                        pareja(mesa, ia.getCartas())) > (ganadorPareja(pareja(mesa, j1.getCartas()))))) {
                        System.out.println("La IA gana por " + pareja(mesa, ia.getCartas()));
                        ultimoTurno = true;
                        in.nextLine();
                        
                        
                    } else {
                        System.out.println("Empate");
                        darMagiKoins(j1, cantEnJuego);
                        ultimoTurno = true;
                        in.nextLine();
                        
                    }
                }

                Tools.limpiarPantalla();

            }
        } while (retirarse != true && ultimoTurno != true);

        if (retirarse == true) {
            
            retirarse();
            System.out.println("Te has retirado y tu rival gana " + cantEnJuego + " MagiKoins");
            in.nextLine();
            Tools.limpiarPantalla();
        }
        

    }

    public String pareja(String[] mesa, String[] cartas) {
        String[] cartasJug;
        String tempJug = "", tempMesa = "";
        String[] cartasMesa;
        String pareja = "";
        for (int i = 0; i < cartas.length; i++) {
            cartasJug = cartas[i].split(" ");
            tempJug += cartasJug[0] + " ";
        }
        cartasJug = tempJug.split(" ");

        for (int i = 0; i < mesa.length; i++) {
            cartasMesa = mesa[i].split(" ");
            tempMesa += cartasMesa[0] + " ";
        }
        cartasMesa = tempMesa.split(" ");

        int par = 0;
        for (int i = 0; i < mesa.length; i++) {
            if (cartasJug[0].equals(cartasMesa[i])) {
                pareja += cartasMesa[i] + " ";
                par++;
            }
            if (cartasJug[1].equals(cartasMesa[i])) {
                pareja += cartasMesa[i] + " ";
                par++;
            }
        }

        pareja = pareja.trim();
        String[] trio = pareja.split(" ");
        if (trio.length > 1) {
            if (trio[0].equals(trio[1])) {
                par = 4;
            }
        }

        if (par == 1) {
            return "una pareja de " + pareja;
        } else if (par == 2) {
            if (pareja.contains(" ")) {
                pareja = pareja.replace(" ", " y ");
            }
            return "doble pareja de " + pareja;
        } else if (par == 3) {
            if (pareja.contains(" ")) {
                pareja = pareja.replace(" ", " y ");
            }
            return "triple pareja de " + pareja;
        } else if (par == 4) {
            return "trio de " + trio[0].toString();
        } else {
            return "no tiene ninguna pareja";
        }
    }

    public int ganadorPareja(String frs) {
        int num = 0;

        if (frs.substring(0, 3).contains("una")) {
            num = 1;
        } else if (frs.contains("doble")) {
            num = 2;
        } else if (frs.contains("triple")) {
            num = 3;
        } else if (frs.contains("trio")) {
            num = 4;
        } else if (frs.substring(0, 2).contains("no")) {
            num = 0;
        }
        return num;
    }

    public void apostarSeguirRet(Jugador j) {
        int cant;
        String nOp;
        int nOpcion = -1;
        do {

            nOp = in.nextLine();
            if (Tools.controlErrores(nOp)) {
                nOpcion = Integer.parseInt(nOp);
            }
            switch (nOpcion) {
                case 1:
                    break;
                case 2:
                    System.out.print("Tienes " + j1.dinero + " MagiKoins");
                    System.out.println();
                    System.out.print("| 1 - All-in | 2 - Cantidad personalizada | 3 - Vovler atrás |");
                    String opAp;
                    int opcionApostar = -1;
                    do {
                        opAp = in.nextLine().trim();
                        if (Tools.controlErrores(opAp)) {
                            opcionApostar = Integer.parseInt(opAp);
                        }

                        switch (opcionApostar) {
                            case 1:
                                int allin = j1.dinero;
                                apostar(j1.dinero, j);
                                System.out.println("Has apostado " + allin + " MagiKoins");
                                break;
                            case 2:
                                System.out.println("¿Cantidad que quieres apostar?");
                                String opCantPers;
                                int cantPersonalizada;
                                boolean si;
                                do {
                                    opCantPers = in.nextLine();
                                    si = Tools.controlErrores(opCantPers);
                                    if (si) {
                                        cantPersonalizada = Integer.parseInt(opCantPers);
                                        if (cantPersonalizada < j.dinero) {
                                            apostar(cantPersonalizada, j);
                                        } else {
                                            System.out.println(
                                                    "Estas intentando apostar más MagiKoins de los que tienes");
                                            System.out.print("Vuelve a introducir una cantidad correcta: ");
                                            si = false;
                                        }

                                    } else {
                                        si = false;
                                        System.out.println("Opción no valida");
                                    }

                                } while (si != true);
                                break;
                            case 3:
                                volverAtras = true;
                                break;
                            default:
                                System.out.println("Opción no valida");
                                break;
                        }
                    } while (Tools.controlErrores(opAp) != true || opcionApostar > 3);
                    break;
                case 3:
                    retirarse();
                    retirarse = true;
                    break;
                default:
                    System.out.println("Opcion no valida!");
                    break;
            }
        } while ((Tools.controlErrores(nOp) != true) || (nOpcion > 3));

    }

    public int apostar(int cant, Jugador j) {
        j.dinero -= cant;
        cantEnJuego += cant;
        return cant;
    }

    public void darMagiKoins(Jugador j, int cant) {
        j.dinero += cantEnJuego * 2;
    }

    public void retirarse() {
        darMagiKoins(ia, cantEnJuego);
    }
}
