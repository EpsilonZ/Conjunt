template<typename T>
void conjunt<T>::_afegir_darrere(node * aux_node, node * aux_conjunt, node * aux_conjunt_previ){
	if(davant==aux_conjunt){											
		aux_node->_seg=davant;
		davant=aux_node;
	}
	else{
		aux_conjunt_previ->_seg=aux_node;
		aux_node->_seg=aux_conjunt;
	}
}
template<typename T>
void conjunt<T>::_delete(node *c){
	--_num_elements;
	if(c==davant){
		if(c->_seg!=NULL){	
			davant=davant->_seg;
			delete c;
		}
		else{
			delete c;
			davant=NULL;		
		}
	}
	else 
		delete c;
}	
template <typename T>
void conjunt<T>::aux_destructora(node *c) { 
  while(c!=NULL){
		node *aux_delete=c;
		c=c->_seg;
		_delete(aux_delete);
  }
}
template <typename T> 
typename conjunt<T>::node* conjunt<T>::tcopy(const node* origen) throw(error){
  node *desti=NULL;
  if(origen!=NULL){
    desti=new node();
		try{
    	desti->info=origen->info;
		}
		catch(...){
			delete desti;
			throw;
		}
    desti->_seg=tcopy(origen->_seg);
  }
  return desti;
}
template <typename T>
conjunt<T>::conjunt() throw(error) : _num_elements(0), davant(NULL){}

template <typename T>
conjunt<T>::conjunt(const conjunt& B) throw(error){

	_num_elements=B._num_elements;	
	davant=tcopy(B.davant);
	valor_max=B.valor_max;
}
template <typename T>
conjunt<T>::~conjunt() throw(){
	aux_destructora(davant);
}
template <typename T>
conjunt<T>& conjunt<T>::operator=(const conjunt& B) throw(error){			
	try{	
		_num_elements=B._num_elements;
		aux_destructora(davant);	
		davant=tcopy(B.davant);
		valor_max=B.valor_max;
	}	catch(...){
			aux_destructora(davant);
			throw;
	}
	return *this;
}
template <typename T>
void conjunt<T>::insereix(const T& x) throw(error){	

	if(conte(x)) return;
	node *aux_node=new node;
	try{
		aux_node->info=x;
	}catch(...){
		throw;
	}
	++_num_elements;
	aux_node->_seg=NULL;
	if(davant==NULL){
		valor_max=x;
		davant=aux_node;
	}
	else if(davant!=NULL){
		node *aux_conjunt=davant;
		node *aux_conjunt_previ=davant;
		bool insertada=false;
		while(aux_conjunt!=NULL and not insertada){																											
			if(aux_conjunt->info>x)	_afegir_darrere(aux_node,aux_conjunt,aux_conjunt_previ);
			else if(aux_conjunt->_seg==NULL and aux_conjunt->info<x){
					aux_conjunt->_seg=aux_node;
					valor_max=x;
			}
		  insertada= (aux_conjunt->_seg==NULL and aux_conjunt->info<x) or (aux_conjunt->info>x);
			if (not insertada){
				aux_conjunt_previ=aux_conjunt;
				aux_conjunt=aux_conjunt->_seg;
			}
		}
	}
	
}
template <typename T>
void conjunt<T>::unir(const conjunt& B) throw(error){
	
  if(davant==NULL and B.davant!=NULL){
		try{
				davant=tcopy(B.davant);
				valor_max=B.valor_max;
		}
		catch(...){
			aux_destructora(davant);
			throw;
		}
		_num_elements=B._num_elements;
	}
	else{	
		node *aux=davant;	
		node *prev=davant;
		node *aux_B=B.davant;
		while(aux_B!=NULL){
			if(aux->info<aux_B->info){
				if(aux->_seg==NULL){
					++_num_elements;
					node *aux_op=new node;
					aux_op->info=aux_B->info;
					aux->_seg=aux_op;
					aux_op->_seg=NULL;
					valor_max=aux_B->info;
				}
				prev=aux;
				aux=aux->_seg;
			}	else if(aux->info>aux_B->info){
				++_num_elements;
				node *aux_op=new node;
				aux_op->info=aux_B->info;
				_afegir_darrere(aux_op,aux,prev);
				prev=aux_op;
				aux_B=aux_B->_seg;
			}	else if(aux->info==aux_B->info){
				aux_B=aux_B->_seg;
				if(aux->_seg!=NULL){
					prev=aux;
					aux=aux->_seg;
				}
			}
		}
	}
}

template <typename T>
void conjunt<T>::intersectar(const conjunt& B) throw(error){

	node *aux = davant;
	node *aux_B = B.davant;
	node *prev = davant;
  while(aux!=NULL){
		if(aux_B==NULL){
			node *aux_p=aux;
			aux=aux->_seg;
			prev->_seg=aux;
			_delete(aux_p);
		}
		else if(aux_B->info>aux->info){
			node *aux_delete=aux;
			if(aux->_seg!=NULL){
				if(davant==aux)	prev=davant;
				else	prev->_seg=aux->_seg;
				aux=aux->_seg;
				_delete(aux_delete);
			}
			else if(davant==aux){
				_delete(aux_delete);
				return;
			}
		}
		else if(aux_B->info==aux->info){
			prev=aux;
			valor_max=aux->info;
			aux=aux->_seg;
			aux_B=aux_B->_seg;
		}
		else if(aux_B->info<aux->info)	aux_B=aux_B->_seg;
	}
}
template <typename T>
void conjunt<T>::restar(const conjunt& B) throw(error){
	
		node *aux=davant;
		node *prev=davant;
		node *aux_B=B.davant;
    while(aux!=NULL and aux_B!=NULL){
			if(aux->info==aux_B->info){
				if(aux->_seg==NULL)	valor_max=prev->info;
				node *auxdelete=aux;
				if(aux==davant)	prev=aux->_seg;
				else	prev->_seg=aux->_seg;
				aux=aux->_seg;
				aux_B=aux_B->_seg;
				_delete(auxdelete);
			}
			else if(aux->info>aux_B->info)	aux_B=aux_B->_seg;
			else{
				prev=aux;
				aux=aux->_seg;
			}
		}
}
template <typename T>
conjunt<T> conjunt<T>::operator+(const conjunt& B) const throw(error){
	
		conjunt resultat_suma;
		try{
		resultat_suma=*this;
		resultat_suma.unir(B);
		}
		catch(...){
			node *aux=resultat_suma.davant;
			while(aux!=NULL){	
				node *p=aux;
				aux=aux->_seg;
				delete p;
			}
			throw;
		}
return resultat_suma;

} 
template <typename T>
conjunt<T> conjunt<T>::operator*(const conjunt& B) const throw(error){
		conjunt resultat_producte;
		try{
			conjunt resultat_producte=*this;
			resultat_producte.intersectar(B);
		}
		catch(...){
			node *aux=resultat_producte.davant;
			while(aux!=NULL){	
				node *p=aux;
				aux=aux->_seg;
				delete p;
			}
			throw;
		}
		return resultat_producte;
}
template <typename T>
conjunt<T> conjunt<T>::operator-(const conjunt& B) const throw(error){
	
	conjunt resultat_resta;
	try{
	conjunt resultat_resta=*this;
	resultat_resta.restar(B);
	}
	catch(...){
		node *aux=resultat_resta.davant;
		while(aux!=NULL){	
			node *p=aux;
			aux=aux->_seg;
			delete p;
		}
		throw;
	}
	return resultat_resta;


	
}

template <typename T>
bool conjunt<T>::conte(const T& x) const throw(){
	node *aux=davant;
  bool esta=false;
  while(aux!=NULL and not esta){
    if(aux->info==x)	esta=true;
    else	aux=aux->_seg;
  }
  return esta;
}
template <typename T>
T conjunt<T>::max() const throw(error) {
	
		if(davant==NULL)	throw error(NoMinMaxEnConjBuit);
		else	return valor_max;
}
template <typename T>
T conjunt<T>::min() const throw(error) {
	if(davant==NULL) 	throw error(NoMinMaxEnConjBuit);
	else	return davant->info;
}
template <typename T>
int conjunt<T>::card() const throw(){
	return _num_elements;
}
template <typename T>
bool conjunt<T>::operator==(const conjunt& B) const throw(){
  bool son_iguals=false;
  if(B.davant==NULL and davant==NULL)	son_iguals=true;
	else if((B.davant!=NULL and davant==NULL) or (B.davant==NULL and davant!=NULL)) son_iguals=false;
  else if(_num_elements==B._num_elements){
    node* aux_implicit=davant;
    node* aux_cj=B.davant;
    while(aux_cj!=NULL and not son_iguals){
      if(aux_implicit->info!=aux_cj->info)	son_iguals=true;
      else{
        aux_implicit=aux_implicit->_seg;
        aux_cj=aux_cj->_seg;
      }
		}
 	 son_iguals= not son_iguals;
	}
  return son_iguals;
}
template <typename T>
bool conjunt<T>::operator!=(const conjunt& B) const throw() {
	return not (*this==B);
}
template <typename T>
void conjunt<T>::print(ostream& os) const throw(){

	if(davant==NULL)	os << "[]";
  else{
    os<<"[";
    node *aux=davant;
    while(aux->_seg!=NULL){
      os<<aux->info<<" ";
      aux=aux->_seg;
    }
    os<<aux->info<<"]";
  }
}
