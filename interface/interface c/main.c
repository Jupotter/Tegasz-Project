#include <stdlib.h>
#include <gtk/gtk.h>

int main(int argc, char **argv)
{
    /* Variables */
    GtkWidget * MainWindow;  
    GtkWidget *VBox;
    int icone;

    static GtkWidget *Toolbar = NULL;
    /* Initialisation de GTK+ */
    gtk_init(&argc, &argv);


    /* Création de la fenêtre */
    MainWindow = gtk_window_new(GTK_WINDOW_TOPLEVEL);
    g_signal_connect(G_OBJECT(MainWindow), "delete-event", G_CALLBACK(gtk_main_quit), NULL);

//taille
    gtk_window_set_default_size(GTK_WINDOW(MainWindow), 300,50);
    
//titre
    gtk_window_set_title(GTK_WINDOW(MainWindow), "Lecteur audio TeGaSz");

//icone
    icone = gtk_window_set_icon_from_file(GTK_WINDOW(MainWindow), "icone.ico", NULL);

 
// barre d'outils
  VBox = gtk_vbox_new(FALSE, 0);
   gtk_container_add(GTK_CONTAINER(MainWindow), VBox);

  Toolbar = gtk_toolbar_new();
  gtk_box_pack_start(GTK_BOX(VBox), Toolbar, FALSE, FALSE, 0);


 gtk_toolbar_insert_stock(GTK_TOOLBAR(Toolbar),
			  GTK_STOCK_OPEN,
      "Ouvrir",
      NULL,
      NULL,
      NULL,
      -1);

 gtk_toolbar_insert_stock(GTK_TOOLBAR(Toolbar),
			  GTK_STOCK_MEDIA_PLAY,
      "Jouer",
      NULL,
      NULL,
      NULL,
      -1);

 gtk_toolbar_insert_stock(GTK_TOOLBAR(Toolbar),
			  GTK_STOCK_MEDIA_STOP,
      "STOP",
      NULL,
      NULL,
      NULL,
      -1);

 gtk_toolbar_insert_stock(GTK_TOOLBAR(Toolbar),
			  GTK_STOCK_MEDIA_NEXT,
      "Titre suivant",
      NULL,
      NULL,
      NULL,
      -1);

gtk_toolbar_insert_stock(GTK_TOOLBAR(Toolbar),
			 GTK_STOCK_MEDIA_FORWARD,
      "Titre precedent",
      NULL,
      NULL,
      NULL,
      -1);

gtk_toolbar_insert_stock(GTK_TOOLBAR(Toolbar),
			 GTK_STOCK_JUSTIFY_FILL,
      "Playlist",
      NULL,
      NULL,
      NULL,
      -1);


 gtk_toolbar_append_space(GTK_TOOLBAR(Toolbar));

gtk_toolbar_insert_stock(GTK_TOOLBAR(Toolbar),
      GTK_STOCK_HELP,
      "Aide",
      NULL,
      NULL,
      NULL,
      -1);

 gtk_toolbar_append_space(GTK_TOOLBAR(Toolbar));

gtk_toolbar_insert_stock(GTK_TOOLBAR(Toolbar),
      GTK_STOCK_QUIT,
      "Fermer",
      NULL,
      G_CALLBACK(gtk_main_quit),
      NULL,
      -1);

/* Affichage et boucle évènementielle */
    gtk_widget_show_all(MainWindow);
    gtk_main();




    /* On quitte.. */
    return EXIT_SUCCESS;
}
