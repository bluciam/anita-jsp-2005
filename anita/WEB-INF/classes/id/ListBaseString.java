/** First attempt at defining a dimension value as a list.
 *  This will pack and unpack an encoded list (item1,item2,item3,...)
 *  which is the actual value of the dimension.
 */


/* When reimplementing check the methods Arrays.toList and the other */

package id;
import java.util.*;

public class ListBaseString {

  public static LinkedList unPack(String listaSarta) {
    LinkedList lista = new LinkedList();
    String[] arreglo = listaSarta.split(",");
    boolean added    = false;
    for (int i = 0; i < arreglo.length; i++) {
      added = lista.add((String)arreglo[i]); 
    }
    return lista;

  }


  public static String pack(LinkedList lista) {
    StringBuffer otraLista = new StringBuffer();

      int i = 0;
         while (i < (lista.size() - 1)) {
           otraLista.append(lista.get(i) + ",");
           i++;
         }
      otraLista.append(lista.get(i));
      return otraLista.toString();
  }

/*
*/
  public String DeleteElem(String stringLista, String elem) {
    LinkedList lista = unPack(stringLista);
//    if (lista.size() > 0) {
       lista.remove(elem);
//    }
    return pack(lista);
  }

  public String AddElem(String stringLista, String elem) {
    LinkedList lista = unPack(stringLista);
    lista.add(elem);
    return pack(lista);
  }


  public boolean HasElem(String stringLista, String elem) {
    LinkedList lista = unPack(stringLista);
    return lista.contains(elem);
  }



/*
String pack(LinkedList)
and
LinkedList unPack(String list)

int i = 0;
while (i < (lista.size() - 1)) {
  otraLista.append(lista.get(i) + ",");
  i++;
}

*/


}
