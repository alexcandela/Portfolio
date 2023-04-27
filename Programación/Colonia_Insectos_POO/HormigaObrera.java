package UF4A5_Colonia_Insectos;

public class HormigaObrera extends Hormiga implements Obrera{
    public HormigaObrera(){
        super();
    }

    public int recolectar(){
        return (int)(Math.random()*(40 - 1) + 1);
    }
}
