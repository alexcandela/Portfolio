package uf4p1.lords.of.steel;

public abstract class Personatge {

    protected String nom;
    protected String categoria;
    protected String devocio;
    protected Arma arma;
    protected int[] statsPrimaries = new int[5];
    protected int[] statsSecundaries = new int[4];
    private int experiencia = 0;
    private int nivell = 0;
    static int contador = 0;

    public Personatge(String nom, String categoria, String devocio, Arma arma, int[] statsPrimaries) {
        this.nom = nom;
        this.categoria = categoria;
        this.devocio = devocio;
        this.arma = arma;
        this.statsPrimaries = statsPrimaries;
        contador++;
    }

    protected abstract void setStatsSecundaries(int[] statsPrimaries);

    protected void setStatsPrimaries(int[] newStats) {
        this.statsPrimaries = newStats;
    }

    protected int[] getStatsPrimaries() {
        return this.statsPrimaries;
    }

    public String getNom() {
        return nom;
    }

    public String getCategoria() {
        return categoria;
    }

    public String getDevocio() {
        return devocio;
    }

    public int getNivell() {
        return nivell;
    }

    public int getExperiencia() {
        return experiencia;
    }

    public Arma getArma() {
        return arma;
    }

    public void printStatsPrimaries() {
        for (int i = 0; i < statsPrimaries.length; i++) {
            switch (i) {
                case 0:
                    System.out.println("Força: " + statsPrimaries[0]);
                    break;
                case 1:
                    System.out.println("Constitució: " + statsPrimaries[1]);
                    break;
                case 2:
                    System.out.println("Velocitat: " + statsPrimaries[2]);
                    break;
                case 3:
                    System.out.println("Intel·ligència: " + statsPrimaries[3]);
                    break;
                case 4:
                    System.out.println("Sort: " + statsPrimaries[4]);
                    break;
                default:
                    break;
            }
        }
    }

    public void getStatsSecundaries() {
        for (int i = 0; i < statsPrimaries.length; i++) {
            switch (i) {
                case 0:
                    System.out.println("PS: " + statsSecundaries[0]);
                    break;
                case 1:
                    System.out.println("PD: " + statsSecundaries[1]);
                    break;
                case 2:
                    System.out.println("PA: " + statsSecundaries[2]);
                    break;
                case 3:
                    System.out.println("PE: " + statsSecundaries[3]);
                    break;
                default:
                    break;
            }
        }
    }

    public int getForca() {
        return statsPrimaries[0];
    }

    public int getConstitució() {
        return statsPrimaries[1];
    }

    public int getVelocitat() {
        return statsPrimaries[2];
    }

    public int getIntelligencia() {
        return statsPrimaries[3];
    }

    public int getSort() {
        return statsPrimaries[4];
    }

    public int getPuntsSalut() {
        return statsSecundaries[0];
    }

    public int getPuntsDany() {
        return statsSecundaries[1];
    }

    public int getProbabilitatAtacar() {
        return statsSecundaries[2];
    }

    public int getProbabilitatEsquivar() {
        return statsSecundaries[3];
    }

    // Combat
    public void rebDany(int dany) {
        this.statsSecundaries[0] -= dany;
    }

    public void restaurarPs(int restauracio) {
        this.statsSecundaries[0] += restauracio;
    }

    public void augmentarPE(int experiencia) {
        this.experiencia += experiencia;
    }

    public void pujarNivell(boolean pujaNivell) {
        if (pujaNivell) {
            this.nivell++;
            this.experiencia = 0;
            for (int i = 0; i < statsPrimaries.length; i++) {
                this.statsPrimaries[i] += 1;
            }

        }

    }

    @Override
    public String toString() {
        return "Nom: " + nom + "\nArma: " + arma + "\nCategoria: " + categoria + "\nDevoció: "
                + devocio + "\nNivell: " + nivell + "\nEstadístiques:\n Força: " + statsPrimaries[0]
                + "\n Constitució : " + statsPrimaries[1] + "\n Velocitat : " + statsPrimaries[2]
                + "\n Intel·ligència : " + statsPrimaries[3] + "\n Sort : " + statsPrimaries[4]
                + "\n Punts de Salut : " + statsSecundaries[0] + "\n Punts de Dany : " + statsSecundaries[1]
                + "\n Probabilitat d'Atac : " + statsSecundaries[2] + "\n Probabilitat d'Esquivar : " + statsSecundaries[3] + "\n";
    }

}
