public class Jugador {
    String[] cartas;
    int dinero;
    
    public Jugador(int dinero) {
        cartas = new String[2];
        this.dinero = dinero;
        
    }

    public void mostrarCartas(){
        System.out.println("| " + cartas[0] + " | " + cartas[1] + " |");
    }
    public String[] getCartas(){
        return cartas;
    }

    public void recibirCartas(String[] car){
        cartas = car;
    }
}
