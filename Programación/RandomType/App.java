import java.util.Scanner;

public class App {
    public static void main(String[] args) {

        String[] frases = new String[10];
        frases[0] = "El exito es la suma de pequeños esfuerzos repetidos dia tras dia.";
        frases[1] = "La creatividad es la inteligencia divirtiendose.";
        frases[2] = "La unica forma de hacer un gran trabajo es amar lo que haces.";
        frases[3] = "La paciencia es la clave del exito.";
        frases[4] = "No te preocupes por los fracasos, preocupate por las posibilidades que pierdes cuando ni siquiera lo intentas.";
        frases[5] = "La vida es 10% lo que nos sucede y 90% como reaccionamos ante ello.";
        frases[6] = "El aprendizaje es un tesoro que seguira a su dueño a todas partes.";
        frases[7] = "La mejor manera de predecir el futuro es creandolo.";
        frases[8] = "El optimismo es la fe que conduce al logro. Nada puede hacerse sin esperanza y confianza.";
        frases[9] = "El unico lugar donde el exito viene antes que el trabajo es en el diccionario.";

        int random = (int) (Math.random() * frases.length);
        calcularWPM(frases[random]);

    }

    public static void calcularWPM(String frs) {
        Scanner in = new Scanner(System.in);
        int palabrasIngresadas = 0;

        System.out.println(frs);
        long tiempoInicio = System.currentTimeMillis();

        String textoIngresado = in.nextLine();
        palabrasIngresadas += textoIngresado.split(" ").length;

        long tiempoFinal = System.currentTimeMillis();
        long tiempoTranscurrido = tiempoFinal - tiempoInicio;

        double wpm = (palabrasIngresadas * 60000) / tiempoTranscurrido;

        if (wpm <= 20) {
            System.out.println("WPM: " + wpm + ". Tienes un nivel basico");
        } else if (wpm > 20 && wpm < 40) {
            System.out.println("WPM: " + wpm + ". Tienes un nivel intermedio");
        } else if (wpm >= 40 && wpm < 60) {
            System.out.println("WPM: " + wpm + ". Tienes un nivel avanzado");
        } else if (wpm >= 60) {
            System.out.println("WPM: " + wpm + ". Tienes un nivel profesional");
        }
        if (!textoIngresado.equals(frs)) {
            System.out.println("La frase no es exactamente igual.");
        }
    }
}
