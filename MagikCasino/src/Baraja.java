public class Baraja {
    static protected String[] tipo = { "Picas", "Corazones", "Rombos", "Tréboles" };
    static protected String[] carta = { "AS", "Dos", "Tres", "Cuatro", "Cinco", "Seis", "Siete", "Ocho", "Nueve",
            "Diez", "Jota", "Reina", "Rey" };
    String[] baraja;

    public Baraja() {
        baraja = crearBaraja();
    }

    public static String[] crearBaraja() {
        String[] baraja = new String[52];
        int contCartas = 0;
        int contTipo = 0;
        for (int i = 0; i < baraja.length; i++) {
            if (contCartas == 13) {
                contCartas = 0;
                contTipo++;
            }
            baraja[i] = carta[contCartas] + " de " + tipo[contTipo];
            contCartas++;
        }

        return baraja;
    }

    public void mostrarBaraja() {
        for (int i = 0; i < baraja.length; i++) {
            System.out.println((i + 1) + " -- " + baraja[i]);
        }
    }

    public String[] repartirCartas() {
        int random;
        String cartas[] = new String[2];
        for (int i = 0; i < 2; i++) {
            random = (int) (Math.random() * 51);

            while (baraja[random] == null) {
                random = (int) (Math.random() * 51);
            }
            cartas[i] = baraja[random];
            baraja[random] = null;
        }
        return cartas;
    }

    public String[] repartirCartasMesa(String[] mesa) {
        int random;
        for (int i = 0; i < 5; i++) {
            random = (int) (Math.random() * 51);
            while (baraja[random] == null) {
                random = (int) (Math.random() * 51);
            }
            mesa[i] = baraja[random];
            baraja[random] = null;
        }
        return mesa;
    }

    public void mostrarMesa(String[] mesa, int turno) {
        if (turno == 1) {
            System.out.print("| ");
            for (int i = 0; i < 3; i++) {
                System.out.print(mesa[i] + " | ");
            }
        } else if (turno == 2){
            System.out.print("| ");
            for (int i = 0; i < 4; i++) {
                System.out.print(mesa[i] + " | ");
            }
        } else if (turno == 3){
            System.out.print("| ");
            for (int i = 0; i < 5; i++) {
                System.out.print(mesa[i] + " | ");
            }
        }

    }
}
