package UF4A5_Colonia_Insectos;

public class AbejaObrera extends Abeja implements Obrera{
    public AbejaObrera(){
        super();
    }
    
    public int recolectar(){
        return (int)(Math.random()*(40 - 1) + 1);
    }
}
