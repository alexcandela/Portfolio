package uf4p1.lords.of.steel;

public class HumaCaos extends Huma implements Caos {

    public HumaCaos(String nom, String categoria, String devocio, Arma arma, int[] statsPrimaries) {
        super(nom, categoria, devocio, arma, statsPrimaries);

    }

    @Override
    public boolean devocioCaos(int dau, Personatge p) {
        return dau <= Math.round(p.getProbabilitatAtacar() * 0.5);
    }
}
