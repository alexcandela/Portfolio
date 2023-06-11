package uf4p1.lords.of.steel;

import java.util.Scanner;

public class LordsOfSteel {

    static final Scanner in = new Scanner(System.in);
    private static final int maximsPeronatges = 20; //capacitat de personatges guardats

    // Creació de referencies
    static Arma arma;
    static Arma daga = new Arma("daga");
    static Arma espasa = new Arma("espasa");
    static Arma martell = new Arma("martell de combat");

    // Creació d'Arranys llindars d'PEX i punts assiganbles cada nivell
    static int[] nivellsMaxPex = {100, 200, 500, 1000, 2000};
    static int[] maxPuntsAssignar = {60, 65, 70, 75, 80, 85};

    public static void main(String[] args) {

        // Creació de personatges predefinits
        // creem arrays de les stats primàries
        int[] statsPrimaries1 = {10, 10, 10, 14, 18};
        int[] statsPrimaries2 = {12, 10, 18, 10, 10};
        int[] statsPrimaries3 = {18, 7, 7, 14, 14};
        int[] statsPrimaries4 = {12, 18, 10, 10, 10};

        // referenciació i instanciació de personatges
        Personatge alex = new HumaOrdre("Alex", "Humà", "Ordre", espasa, statsPrimaries1);
        alex.setStatsSecundaries(statsPrimaries1);
        Personatge isaac = new MaiaOrdre("Isaac", "Maia", "Ordre", martell, statsPrimaries2);
        isaac.setStatsSecundaries(statsPrimaries2);
        Personatge nil = new MitjaCaos("Nil", "Mitja", "Caos", daga, statsPrimaries3);
        nil.setStatsSecundaries(statsPrimaries3);
        Personatge emilio = new NanCaos("Emilio", "Nan", "Caos", espasa, statsPrimaries4);
        emilio.setStatsSecundaries(statsPrimaries4);

        // Creacio d'Array de personatges 
        Personatge[] personatgesJoc = new Personatge[maximsPeronatges];

        // Inserim els personatges predefinits a l'Array
        personatgesJoc[0] = alex;
        personatgesJoc[1] = isaac;
        personatgesJoc[2] = nil;
        personatgesJoc[3] = emilio;

        // Declaració de variales
        int opcio; // opció del menú principal
        boolean on = true; // mentre que es true el joc s'executa 

        // Introducció al joc Lords of Steel
        System.out.println("***Lords of Steel***");
        System.out.println(
                "Benvingut/da al llegendari mon de Terralunds s’està lliurant "
                + "una cruenta batalla amb les forces de la foscor que "
                + "acabarà decidint el futur dels seus habitants.");
        System.out.println("");

        //Menú Principal
        do {
            System.out.println("1 - Afegir un nou personatge.");
            System.out.println("2 - Esborrar un personatge.");
            System.out.println("3 - Editar un personatge.");
            System.out.println("4 - Iniciar un combat.");
            System.out.println("5 - Sortir.");

            if (in.hasNextInt()) {
                opcio = in.nextInt();
                switch (opcio) {
                    case 1:
                        personatgesJoc = afegirNouPersonatge(personatgesJoc);
                        break;
                    case 2:
                        personatgesJoc = esborrarPersonatge(personatgesJoc);
                        break;
                    case 3:
                        personatgesJoc = editarPersonatge(personatgesJoc);
                        break;
                    case 4:
                        personatgesJoc = iniciarCombat(personatgesJoc);
                        break;
                    case 5:
                        on = false;
                        break;
                    default:
                        System.out.println();
                        System.out.println("Opció no valida!");
                        System.out.println();
                }
            } else {
                System.out.println();
                System.out.println("Això és una lletra! Torna a triar una opció vàlida!");
                System.out.println();
                in.next();
            }

        } while (on);
    }

    // Mètode per afegir un nou personatge al joc.
    public static Personatge[] afegirNouPersonatge(Personatge[] p) {

        //Variables del mètode
        String nom, categoria = "", devocio = "", nomArma = "";
        int nomCategoria, tipusDevocio, tipusArma;
        int[] statsPrimaries = new int[5];

        // Codi
        System.out.println("Creació d'un nou personatge:");
        System.out.print("Escull un Nom: ");
        nom = in.next();

        System.out.print("Escull una Arma: ");
        System.out.printf("(1)%s | (2)%s | (3)%s ", daga, espasa, martell);
        tipusArma = in.nextInt();

        switch (tipusArma) {
            case 1:
                nomArma = "daga";
                break;
            case 2:
                nomArma = "espasa";
                break;
            case 3:
                nomArma = "martell de combat";
                break;
            default:
                break;
        }

        arma = new Arma(nomArma);

        System.out.print("Escull una Categoria:");
        System.out.print(" (1)Humà | (2)Maia | (3)Mitja | (4)Nan ");
        nomCategoria = in.nextInt();

        switch (nomCategoria) {
            case 1:
                categoria = "Humà";
                break;
            case 2:
                categoria = "Maia";
                break;
            case 3:
                categoria = "Mitja";
                break;
            case 4:
                categoria = "Nan";
                break;
            default:
                break;
        }

        System.out.print("Escull una Devoció:");
        System.out.print(" (1)Ordre | (2)Caos ");
        tipusDevocio = in.nextInt();

        switch (tipusDevocio) {
            case 1:
                devocio = "Ordre";
                break;
            case 2:
                devocio = "Caos";
                break;
            default:
                throw new AssertionError("Easter Egg Trobat!");
        }

        // x correspont a la stat primària corresponent de l'array
        int punts, x, aux;

        do {
            punts = 60;
            x = 0;

            System.out.println("Defineix estadístiques principals (minim 3 màxim 18):");

            do {

                switch (x) {
                    case 0:
                        System.out.print("Força: ");
                        break;
                    case 1:
                        System.out.print("Constitució: ");
                        break;
                    case 2:
                        System.out.print("Velocitat: ");
                        break;
                    case 3:
                        System.out.print("Intel·ligència: ");
                        break;
                    case 4:
                        System.out.print("Sort: ");
                        break;

                    default:
                        throw new AssertionError();
                }
                aux = controlError1();
                statsPrimaries[x] = aux;
                punts -= aux;
                System.out.printf("(%d punts restants)\n", punts);
                x++;
            } while (x < 5);

            if (punts != 0) {
                System.out.println("No has assignat bé els punts! Torna a assignar-los!");
            }
        } while (punts != 0);

        switch (nomCategoria) {
            case 1:
                if (devocio == "Ordre") {
                    p[x] = new HumaOrdre(nom, categoria, devocio, arma, statsPrimaries);
                    p[x].setStatsSecundaries(statsPrimaries);
                } else if (devocio == "Caos") {
                    p[x] = new HumaCaos(nom, categoria, devocio, arma, statsPrimaries);
                    p[x].setStatsSecundaries(statsPrimaries);
                }
                break;
            case 2:
                if (devocio == "Ordre") {
                    p[x] = new MaiaOrdre(nom, categoria, devocio, arma, statsPrimaries);
                    p[x].setStatsSecundaries(statsPrimaries);
                } else if (devocio == "Caos") {
                    p[x] = new MaiaCaos(nom, categoria, devocio, arma, statsPrimaries);
                    p[x].setStatsSecundaries(statsPrimaries);
                }
                break;
            case 3:
                if (devocio == "Ordre") {
                    p[x] = new MitjaOrdre(nom, categoria, devocio, arma, statsPrimaries);
                    p[x].setStatsSecundaries(statsPrimaries);
                } else if (devocio == "Caos") {
                    p[x] = new MitjaCaos(nom, categoria, devocio, arma, statsPrimaries);
                    p[x].setStatsSecundaries(statsPrimaries);
                }
                break;
            case 4:
                if (devocio == "Ordre") {
                    p[x] = new NanOrdre(nom, categoria, devocio, arma, statsPrimaries);
                    p[x].setStatsSecundaries(statsPrimaries);
                } else if (devocio == "Caos") {
                    p[x] = new NanCaos(nom, categoria, devocio, arma, statsPrimaries);
                    p[x].setStatsSecundaries(statsPrimaries);
                }
                break;
            default:
                break;
        }

        System.out.println("Personatge creat.\n");

        System.out.println("Resum del teu personatge:\n" + p[x].toString());

        return p;

    }

    // Mètpde per esborrar un personatge del joc.
    public static Personatge[] esborrarPersonatge(Personatge[] p) {
        int opcio = 0;
        char validacio = ' ';
        boolean sortir = false;

        System.out.println("Selecciona el personatge a esborrar | Qualsevol lletra per sortir.");
        llistaPersonatges(p);

        if (in.hasNextInt()) {
            opcio = in.nextInt();
        } else {
            sortir = true;
            in.next();
        }
        if (!sortir) {

            System.out.println("Resum del personatge: \n" + p[opcio]);
            System.out.println("Segur que vols borrar " + p[opcio].getNom() + " ?(y/n)");
            validacio = in.next().charAt(0);
            if (validacio == 'y') {
                for (int i = opcio; i < maximsPeronatges - 1; i++) {
                    p[i] = p[i + 1];
                }
                p[p.length - 1] = null;
                Personatge.contador--;
                System.out.println("Personatge borrat.");
            } else {
                System.out.println("Personatge no borrat.");
            }
        }

        return p;
    }

    // Mètode per editar les estadístiques d'un personatge.
    public static Personatge[] editarPersonatge(Personatge[] p) {
        System.out.println("Selecciona el personatge a editar.");
        llistaPersonatges(p);
        int opcio;
        opcio = in.nextInt();
        System.out.println("Configuració de " + p[opcio].getNom());
        int opEditar;
        do {
            System.out.print("Veure stats(1) Editar(2) Sortir(3) ");
            opEditar = in.nextInt();
            switch (opEditar) {
                case 1:
                    System.out.println(p[opcio]);
                    break;
                case 2:
                    int newStats[] = new int[5];
                    int max = 18 + p[opcio].getNivell();
                    System.out.printf("Defineix estadístiques principals (minim 3 màxim %d): \n", max);
                    int f = 0,
                     c = 0,
                     v = 0,
                     i = 0,
                     s = 0;
                    int punts;
                    do {
                        punts = maxPuntsAssignar[p[opcio].getNivell()];
                        System.out.print("Força: ");
                        do {
                            if (in.hasNextInt()) {
                                f = in.nextInt();
                                if (f >= 3 && f <= max) {
                                    newStats[0] = f;
                                } else {
                                    System.out.print("Error! Torna a escriure el valor: ");
                                }
                            } else {
                                System.out.print("Això és una lletra! Torna a escriure el valor: ");
                                in.next();
                            }
                        } while (f < 3 || f > max);
                        punts -= f;
                        System.out.println("Punts restants: " + punts);
                        System.out.print("Constitució: ");
                        do {
                            if (in.hasNextInt()) {
                                c = in.nextInt();
                                if (c >= 3 && c <= max) {
                                    newStats[1] = c;
                                } else {
                                    System.out.print("Error! Torna a escriure el valor: ");
                                }
                            } else {
                                System.out.print("Això és una lletra! Torna a escriure el valor: ");
                                in.next();
                            }
                        } while (c < 3 || c > max);
                        punts -= c;
                        System.out.println("Punts restants: " + punts);

                        System.out.print("Velocitat: ");
                        do {
                            if (in.hasNextInt()) {
                                v = in.nextInt();
                                if (v >= 3 && v <= max) {
                                    newStats[2] = v;
                                } else {
                                    System.out.print("Error! Torna a escriure el valor: ");
                                }
                            } else {
                                System.out.print("Això és una lletra! Torna a escriure el valor: ");
                                in.next();
                            }
                        } while (v < 3 || v > max);
                        punts -= v;
                        System.out.println("Punts restants: " + punts);

                        System.out.print("Intel·ligència: ");
                        do {
                            if (in.hasNextInt()) {
                                i = in.nextInt();
                                if (i >= 3 && i <= max) {
                                    newStats[3] = i;
                                } else {
                                    System.out.print("Error! Torna a escriure el valor: ");
                                }
                            } else {
                                System.out.print("Això és una lletra! Torna a escriure el valor: ");
                                in.next();
                            }
                        } while (i < 3 || i > max);
                        punts -= i;
                        System.out.println("Punts restants: " + punts);

                        System.out.print("Sort: ");
                        do {
                            if (in.hasNextInt()) {
                                s = in.nextInt();
                                if (s >= 3 && s <= max) {
                                    newStats[4] = s;
                                } else {
                                    System.out.print("Error! Torna a escriure el valor: ");
                                }
                            } else {
                                System.out.print("Això és una lletra! Torna a escriure el valor: ");
                                in.next();
                            }
                        } while (s < 3 || s > max);
                        punts -= s;
                        System.out.println("Punts restants: " + punts);
                        if (punts != 0) {
                            System.out.println("No has assignat bé els punts! Torna a assignar-los!");
                        }
                    } while (punts != 0);
                    p[opcio].setStatsPrimaries(newStats);
                    p[opcio].setStatsSecundaries(newStats);
                    System.out.println("Personatge editat correctament!");

                case 3:
                    break;
                default:
                    System.out.println("Opció no valida!");
                    break;
            }
        } while (opEditar != 3);

        return p;
    }

    // Mètode per iniciar un combat.
    public static Personatge[] iniciarCombat(Personatge[] p) {
        //Declaracio de variables relacionades amb els personatges.
        String nomp1, nomp2;
        int p1, p2;
        //Declaració dels daus
        int[] tripleDaus = new int[4];
        
        // Selecció de personatges
        System.out.println("**Mode Combat**");
        System.out.println("Seleccioni el primer personatge: ");
        llistaPersonatges(p);
        p1 = in.nextInt();
        nomp1 = p[p1].getNom();
        
        System.out.println(nomp1 + " ha estat seleccionat.");
        System.out.println("Seleccioni el segon personatge: ");
        llistaPersonatges(p);
        p2 = in.nextInt();
        
        if (p2 == p1) {
            do {
                System.out.println("El persontatge " + nomp1 + " no es pot seleccionar.");
                System.out.println("Seleccioni un altre personatge:");
                llistaPersonatges(p);
                p2 = in.nextInt();
            } while (p1 == p2);
        }
        
        nomp2 = p[p2].getNom();
        System.out.println(nomp2 + " ha estat seleccionat.\n");
        
        // Variables relacionades amb el combat.
        boolean combat = false;
        int torn, ps1, ps2;
        torn = 1;
        ps1 = p[p1].getPuntsSalut();
        ps2 = p[p2].getPuntsSalut();

        // Començament del combat
        System.out.println("Combat: " + nomp1 + " vs " + nomp2);
        System.out.printf("%s(PS(%d),PD(%d),PA(%d),PE(%d))\n%s(PS(%d),PD(%d),PA(%d),PE(%d))",
                p[p1].getNom(), p[p1].getPuntsSalut(), p[p1].getPuntsDany(), p[p1].getProbabilitatAtacar(), p[p1].getProbabilitatEsquivar(),
                p[p2].getNom(), p[p2].getPuntsSalut(), p[p2].getPuntsDany(), p[p2].getProbabilitatAtacar(), p[p2].getProbabilitatEsquivar());

        int aux1, aux2;
        int guanyador = 0, perdedor = 0;
        String aux3, aux4;
        do {
            
            System.out.println("\nTorn " + torn);
            System.out.printf("%s PS:%d | %s PS:%d\n",
                    p[p1].getNom(), p[p1].getPuntsSalut(), p[p2].getNom(), p[p2].getPuntsSalut());
            
            if (torn % 2 == 1) {
                aux1 = p1;
                aux2 = p2;
                aux3 = nomp1;
                aux4 = nomp2;
            }else{
                aux1 = p2;
                aux2 = p1;
                aux3 = nomp2;
                aux4 = nomp1;
            }
            
            System.out.println("" + aux3 + " ataca.");
            tripleDaus = tiradaTripleDaus(tripleDaus);
            imprimeixResultatDau(tripleDaus);
            
            if (tripleDaus[3] <= p[aux1].getProbabilitatAtacar()) {
                System.out.println(aux3 + " encerta l'atac.");
                tripleDaus = tiradaTripleDaus(tripleDaus);
                imprimeixResultatDau(tripleDaus);

                if (tripleDaus[3] <= p[aux2].getProbabilitatEsquivar()) {
                    System.out.println(aux4 + " esquiva l'atac.");
                    
                    if (esCaos(p[aux2])) {
                        System.out.println(aux4 + " realitza contraatac.");
                        tripleDaus = tiradaTripleDaus(tripleDaus);
                        imprimeixResultatDau(tripleDaus);
                        
                        if (((Caos) p[aux2]).devocioCaos(tripleDaus[3], p[aux2])) {
                            System.out.println(aux4 + " encerta contraatac.");
                            p[aux1].rebDany(p[aux2].getPuntsDany());
                            System.out.println(aux3 + " perd " + p[aux2].getPuntsDany() + " PS i li queden "
                                    + p[aux1].getPuntsSalut() + " PS.");
                        } else {
                            System.out.println(aux4 + " falla contraatac.");
                        }
                    }
                } else {
                    System.out.println(aux4 + " no esquiva l'atac.");
                    p[aux2].rebDany(p[aux1].getPuntsDany());
                    System.out.println(aux4 + " perd " + p[aux1].getPuntsDany() + " PS i li queden "
                            + p[aux2].getPuntsSalut() + " PS.");
                    if (esOrdre(p[aux1])) {
                        ((Ordre) p[aux1]).devocioOrdre(ps1);
                        System.out.println(aux3 + " es recupera a " + p[aux1].getPuntsSalut() + " PS.");
                    }
                    if (p[aux2].getPuntsSalut() <= 0) {
                        combat = true;
                        System.out.println(aux3 + " guanya el combat.");
                        guanyador = aux1;
                        perdedor = aux2; 
                    }
                }
            }else {
                    System.out.println(aux3 + " falla l'atac.");
            }
   
            torn++;
        } while (!combat);
        
        // restaurem la vida dels personatges
        p[p1].restaurarPs(ps1 - p[p1].getPuntsSalut());
        p[p2].restaurarPs(ps2 - p[p2].getPuntsSalut());

        // declaracio de variables en funcio del guanyador i perdedor
        

        /*S'augmenta PEX al guanyador en valor del PS perdedor*/
        p[guanyador].augmentarPE(p[perdedor].getPuntsSalut());
        System.out.printf("%s guanya %d PEX. ", p[guanyador].getNom(), p[perdedor].getPuntsSalut());

        /*
          Es comprova si el personatge és màxim nivell.
          Boolean que comprova si el guanyador puja de nivell (si PEX del guanayor >  PEX corresponent al nivell) 
          Es crida al mètode per imprimir el progres del guanyador al joc. 
        */
        if (p[guanyador].getNivell() < nivellsMaxPex.length) {
            p[guanyador].pujarNivell(p[guanyador].getExperiencia() >= nivellsMaxPex[p[guanyador].getNivell()]);        
        }
        imprimeixProgress(p[guanyador], nivellsMaxPex);
        return p;
    }

    // Mètode per imprimir la llista de personatges del joc.
    public static void llistaPersonatges(Personatge[] p) {
        for (int i = 0; i < p.length; i++) {
            if (p[i] != null) {
                System.out.println("(" + i + ")" + p[i].getNom());
            }
        }
    }

    // Mètode de llençament de 3 daus.
    public static int[] tiradaTripleDaus(int[] dados) {
        dados[0] = (int) (Math.random() * (25) + 1);
        dados[1] = (int) (Math.random() * (25) + 1);
        dados[2] = (int) (Math.random() * (25) + 1);
        dados[3] = dados[0] + dados[1] + dados[2];
        return dados;
    }

    // Mètode per imprimir el resultat del llençament de daus.
    public static void imprimeixResultatDau(int[] daus) {
        System.out.println("Tirada de daus: " + daus[3]);
    }

    // Mètode per imprimir el progrés del guanyador del combat.
    public static void imprimeixProgress(Personatge p, int[] nivells) {
        
        float percentatge;
        if (p.getNivell() >= 5) {
            percentatge = (float) p.getExperiencia() / (float) nivells[p.getNivell() - 1] * 100;
        } else {
            percentatge = (float) p.getExperiencia() / (float) nivells[p.getNivell()] * 100;
        }
        System.out.printf("Progres: Nivell %d (%.2f%%)\n\n", p.getNivell(), percentatge);

    }
    
    // Mètode per saber si el personatge és de devocio Ordre.
    public static boolean esOrdre(Personatge p) {
        return p.getDevocio() == ("Ordre");
    }
    
    // Mètode per saber si el personatge és de devocio Caos.
    public static boolean esCaos(Personatge p) {
        return p.getDevocio() == "Caos";
    }

    // Mètode control d'error utilitzat en afegirNouPersonatge()
    public static int controlError1() {
        int stat = 0;
        do {
            if (in.hasNextInt()) {
                stat = in.nextInt();
                if (stat >= 3 && stat <= 18) {
                    return stat;
                } else {
                    System.out.print("Error! Torna a escriure el valor: ");
                }
            } else {
                System.out.print("Això és una lletra! Torna a escriure el valor: ");
                in.next();
            }
        } while (stat < 3 || stat > 18);
        return stat;
    }

}
