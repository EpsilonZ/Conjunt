#include "cj_enters.hpp"
	


//METODES PRIVATS

void cj_enters::aux_destructora(node *c){
//Pre:cert
//Post:elimina tots els nodes a partir del c 
  if(c!=NULL){
    aux_destructora(c->_pt);
    delete c;
  }
}
  
cj_enters::node* cj_enters::tcopy(const node* origen){
//Pre:cert
//Post:copia tots els nodes a partir de l'origen
  node *desti=NULL;
  if(origen!=NULL){
    desti=new node();
    desti->info=origen->info;
    desti->_pt=tcopy(origen->_pt);
  }
  return desti;
}

//METODES PUBLICS

cj_enters::cj_enters(const cj_enters &cj){
//Constructora per còpia
	_num_elements=cj._num_elements;
  davant=tcopy(cj.davant);
}

cj_enters::cj_enters() : _num_elements(0), davant(NULL) {}
//Constructora per defecte. Crea un conjunt buit

bool cj_enters::conte(int e) const {
//Retorna true si conte l'element e, fals altrament
  node *aux=davant;
  bool esta=false;
  while(aux!=NULL and not esta){
    if(aux->info==e)
      esta=true;
    else
      aux=aux->_pt;
  }
  return esta;
}

cj_enters& cj_enters::operator=(const cj_enters &cj){
//Operador assignació
	aux_destructora(davant);
	davant=tcopy(cj.davant);
	return *this;
}

cj_enters::~cj_enters(){
//Destructora
  aux_destructora(davant);
}

int cj_enters::max() const {
//Retorna el valor maxim del conjunt (comportament si esta buit no definit)
  node *aux=davant;
	while(aux->_pt!=NULL)
		aux=aux->_pt;
	return aux->info;
}

int cj_enters::min() const {
//Retorna el valor minim del conjunt (comportament si esta buit no definit)

  return davant->info;
}

void cj_enters::insereix(int e){
//Insereix un element al conjunt, naturalment, si aquest element e ja pertanyia el metode no fa res
  if(davant==NULL){
    node* afegir_node= new node();
		_num_elements=1;
    afegir_node->info=e;
    afegir_node->_pt=NULL;
    davant=afegir_node;
  }
  else{
		if(not conte(e)){
			node* afegir_node= new node();
			++_num_elements;
			afegir_node->info=e;
			bool insertada=false;
			if(davant->info>e){
				insertada=true;														//PRIMER ELEMENT
				afegir_node->_pt=davant;
				davant=afegir_node;
			}
			node* aux=davant;
			node* previ=davant;
			while(aux->_pt!=NULL and not insertada){
				if(aux->info>e){
					insertada=true;
					previ->_pt=afegir_node;								//ELEMENTS DEL MITG 			
					afegir_node->_pt=aux;
				}
					previ=aux;
					aux=aux->_pt;
	 		}
			if(not insertada){
				if(aux->info>e){
					insertada=true;
					previ->_pt=afegir_node;
					afegir_node->_pt=aux;							//ULTIM ELEMENT
				}
				else{
					aux->_pt=afegir_node;
					afegir_node->_pt=NULL;
				}
			}	
		}
	}
}

int cj_enters::card() const {
//Retorna un enter que ens diu quants elements té el conjunt
  return _num_elements;
}

void cj_enters::unir(const cj_enters& B){
//Unio de conjunts. Opera modificant el conjunt passat implicitament 
  node *aux_B=B.davant;
	while(aux_B!=NULL){										
				insereix(aux_B->info);
				aux_B=aux_B->_pt;
	}			
}
void cj_enters::intersectar(const cj_enters& B){
//Interseccio de conjunts. Opera modificant el conjunt passat implicitament
  if(B.davant==NULL){
    *this=B;
		_num_elements=0;
	}
  else if (davant!=NULL){
		node *aux=davant;
		node *prev=davant;
    while(aux->_pt!=NULL){
			if(not B.conte(aux->info)){
				node *auxoperant=aux;
				if(davant==aux){
					davant=aux->_pt;
					prev=davant;
				}
				else
					prev->_pt=aux->_pt;
				--_num_elements;
				aux=aux->_pt;
				delete auxoperant;
							
			}
			else{
				prev=aux;
				aux=aux->_pt;
			}
		}
		if(not B.conte(aux->info)){
			--_num_elements;
			if(davant==aux){
				delete aux;
				davant=NULL;
			}
			else{
				prev->_pt=NULL;	
				delete aux;
			}
		}
	}
}
void cj_enters::restar(const cj_enters& B){
//Diferencia de conjunts. Opera modificant el conjunt passat implicitament
  if(davant!=NULL and B.davant!=NULL){
		node *aux=davant;
		node *prev=davant;
    while(aux->_pt!=NULL){
			if(B.conte(aux->info)){
				--_num_elements;
				if(davant==aux){
					aux=aux->_pt;
					davant=aux;
					prev=aux;
				}
				else{
			    node *auxoperant=aux;
					prev->_pt=aux->_pt;
					aux=aux->_pt;
			    delete auxoperant;
				}
			}
			else{
				prev=aux;
				aux=aux->_pt;
			}
		}
				
		if(B.conte(aux->info)){
			--_num_elements;		
			if(davant==aux){
				delete aux;
				davant=NULL;
			}
			else{
				delete aux;
				prev->_pt=NULL;
			}
		}
  }
}

cj_enters cj_enters::operator+(const cj_enters& B) const{
//Unio de conjunts, retorna un nou conjunt resultant de la unio dels dos conjunts
	cj_enters resultat_suma(*this);
	
	resultat_suma.unir(B);
	return resultat_suma;

}
cj_enters cj_enters::operator*(const cj_enters& B) const{
//Interseccio de conjunts, retorna un nou conjunt resultant de la interseccio dels dos conjunts
	cj_enters resultat_producte(*this);
	resultat_producte.intersectar(B);
	return resultat_producte;
}
cj_enters cj_enters::operator-(const cj_enters& B) const{
//Diferenia de conjunts, retorna un nou conjunt resultant de la diferència dels dos conjunts
	cj_enters resultat_resta(*this);
	resultat_resta.restar(B);
	return resultat_resta;
}

void cj_enters::print(ostream& os) const {
//Imprimeix per pantalla el conjunt
  if(davant==NULL)
    os<<"[]";
  else{
    os<<"[";
    node *aux=davant;
    while(aux->_pt!=NULL){
      os<<aux->info<<" ";
      aux=aux->_pt;
    }
    os<<aux->info<<"]";
  }
}

bool cj_enters::operator==(const cj_enters &cj) const {
//Retorna true si els dos conjunts són iguals(tenen mateixos elements), fals altrament
  bool son_iguals=false;
  if(cj.davant==NULL and davant==NULL)
    son_iguals=true;
  else if(_num_elements==cj._num_elements){
      node* aux_implicit=davant;
      node* aux_cj=cj.davant;
      while(aux_cj!=NULL and not son_iguals){
        if(aux_implicit->info!=aux_cj->info)
	  			son_iguals=true;
        else{
          aux_implicit=aux_implicit->_pt;
          aux_cj=aux_cj->_pt;
        }
		}
    son_iguals= not son_iguals;
	}
  return son_iguals;
}

bool cj_enters::operator!=(const cj_enters& B) const{
//Retorna true si els dos conjunts són diferents(tenen diferents elements), fals altrament
	return not (*this==B) ;
}
