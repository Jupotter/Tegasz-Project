#include <stdlib.h>
#include <gtk/gtk.h>

int main(int argc, char **argv)
{
    /* Variables */
    GtkWidget * MainWindow = NULL;

    /* Initialisation de GTK+ */
    gtk_init(&argc, &argv);

    /* Cr�ation de la fen�tre */
    MainWindow = gtk_window_new(GTK_WINDOW_TOPLEVEL);
    g_signal_connect(G_OBJECT(MainWindow), "delete-event", G_CALLBACK(gtk_main_quit), NULL);

    /* Affichage et boucle �v�nementielle */
    gtk_widget_show(MainWindow);
    gtk_main();

    /* On quitte.. */
    return EXIT_SUCCESS;
}
