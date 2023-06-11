package uf4p1.lords.of.steel;


public class Arma {
    String nom;
    int WPOW;
    int WVEL;
    
    public Arma(String nom) {
        this.nom = nom;
        switch (nom) {
            case "daga":
                this.WPOW = 5;
                this.WVEL = 15;
                break;
            case "espasa":
                this.WPOW = 10;
                this.WVEL = 10;
                break;
            case "martell de combat":
                this.WPOW = 15;
                this.WVEL = 5;
                break;
            default:
                break;
        }
    }
    public int getWPOW(){
        return WPOW;
    }
    public int getWVEL(){
        return WVEL;
    }
            
    @Override
    public String toString() {
        return nom+" {WPOW: "+WPOW+", WVEL: "+WVEL+"}";
    }
}
