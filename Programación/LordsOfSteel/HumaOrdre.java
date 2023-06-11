package uf4p1.lords.of.steel;

public class HumaOrdre extends Huma implements Ordre {

    public HumaOrdre(String nom, String categoria, String devocio, Arma arma, int[] statsPrimaries) {
        super(nom, categoria, devocio, arma, statsPrimaries);

    }

    @Override
    public void devocioOrdre(int vida) {

        statsSecundaries[0] += (int) Math.round(vida * 10.0 / 100);
        if (statsSecundaries[0] > vida) {
            statsSecundaries[0] = vida;
        }

    }
}
