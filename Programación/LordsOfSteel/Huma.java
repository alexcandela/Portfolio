package uf4p1.lords.of.steel;

public class Huma extends Personatge {

    public Huma(String nom, String categoria, String devocio, Arma arma, int[] statsPrimaries) {
        super(nom, categoria, devocio, arma, statsPrimaries);

    }

    @Override
    protected void setStatsSecundaries(int[] statsPrimaries) {
        this.statsSecundaries[0] = (statsPrimaries[0] + statsPrimaries[1]) + statsPrimaries[3]; //especialització en ps
        this.statsSecundaries[1] = (int) Math.round((statsPrimaries[0] + arma.WPOW) / 4.0);     //pd
        this.statsSecundaries[2] = statsPrimaries[3] + statsPrimaries[4] + arma.WVEL;           //pa
        this.statsSecundaries[3] = statsPrimaries[2] + statsPrimaries[3] + statsPrimaries[4];   //pe
    }

}
