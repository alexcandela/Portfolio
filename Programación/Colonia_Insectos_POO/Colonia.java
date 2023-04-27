package UF4A5_Colonia_Insectos;

import javax.swing.text.StyledEditorKit.ForegroundAction;

public class Colonia {
    private Insecto insectos[];
    private int numObreras;
    private int numReinas;
    int comida;

    public Colonia(String tipo, int numObreras, int numReinas, int comida) {
        this.insectos = new Insecto[numObreras + numReinas];
        this.numObreras = numObreras;
        this.numReinas = numReinas;
        this.comida = comida;

        for (int i = 0; i < numObreras; i++) {
            if (tipo.equals("hormigas")) {
                insectos[i] = new HormigaObrera();
                System.out.println("Nace una hormiga obrera con hambre: " + insectos[i].hambre);
            } else if (tipo.equals("abejas")) {
                insectos[i] = new AbejaObrera();
                System.out.println("Nace una abeja obrera con hambre: " + insectos[i].hambre);
            }
        }
        for (int i = numObreras; i < numObreras + numReinas; i++) {
            if (tipo.equals("hormigas")) {
                insectos[i] = new HormigaReina();
                System.out.println("Nace una hormiga reina con hambre: " + insectos[i].hambre);
                ((Reina)insectos[i]).reinar();
            } else if (tipo.equals("abejas")) {
                insectos[i] = new AbejaReina();
                System.out.println("Nace una abeja reina con hambre: " + insectos[i].hambre);
                ((Reina)insectos[i]).reinar();
            }
        }
    }

    public boolean comer() {
        if (comida > 0) {
            for (int i = 0; i < insectos.length; i++) {
                if (comida <= 0) {
                    System.out.println("No hay suficiente comida para toda la colonia, la colonia morirá pronto.");
                    comida = 0;
                    
                    return false;
                }
                else {
                    comida -= insectos[i].comer();
                    System.out.println("Un insecto come y la comida baja a " + comida);
                }

            }
            System.out.println("Comida actual: " + comida);
            return true;
        }
        System.out.println("¡No hay comida!. ¡La colonia ha muerto!");
        return false;
    }

    public void recolectar() {
        if (comida > 0) {
            for (int i = 0; i < numObreras; i++) {
                comida += ((Obrera) insectos[i]).recolectar();
                System.out.println("Una obrera recolecta y la comida sube a " + comida);
            }
            System.out.println("Comida actual: " + comida);
            
        }
        else {
            System.out.println("¡La colonia no tiene fuerzas para recolectar!");
        }       
    }
}
