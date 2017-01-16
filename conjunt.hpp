#ifndef _CONJUNT_HPP_
#define _CONJUNT_HPP_
#include <iostream>
#include <esin/error>

using namespace std;

template <typename T>
class conjunt {

public:

  conjunt() throw(error) ;

  conjunt(const conjunt& B) throw(error);

  ~conjunt() throw();

  conjunt& operator=(const conjunt& B) throw(error);

  void insereix(const T& x) throw(error);
  
  void unir(const conjunt& B) throw(error); 
  void intersectar(const conjunt& B) throw(error);
  void restar(const conjunt& B) throw(error);

  conjunt operator+(const conjunt& B) const throw(error); 
  conjunt operator*(const conjunt& B) const throw(error);
  conjunt operator-(const conjunt& B) const throw(error);

  bool conte(const T& x) const throw();

  T max() const throw(error);
  T min() const throw(error);

  int card() const throw() ;

  bool operator==(const conjunt& B) const throw() ;
  bool operator!=(const conjunt& B) const throw() ;

  void print(ostream& os) const throw() ;

  static const int NoMinMaxEnConjBuit = 10; 

private:
  int _num_elements;
  struct node{
    node *_seg;
    T info;
  };
  node *davant;
	T valor_max;
  node* tcopy(const node* origen) throw(error);
  void aux_destructora(node *c);
	void _delete(node *c);
	void _afegir_darrere(node * aux_node, node * aux_conjunt, node * aux_conjunt_previ);
};
#include "conjunt.t"
#endif
