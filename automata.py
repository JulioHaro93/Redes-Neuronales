from automata.fa.dfa import DFA
from visual_automata.fa.dfa import VisualDFA

"""
Haro capetillo Julio Cesar
Autómata Finito Determinista

"""
bolAux=True
i=1
q=[]

while bolAux ==True:
  try:
    print("Ingrese el número de estados que necesita")
    data=input()
    x=0
    data = int(data)
    if data ==0:
      print("No puede haber un autómata con 0 estados")
    for x in range(data):
      estado = 'q'+str(x)
      q.append(estado)
    print('¿agregar estados?(s/n):')
    choose=input()
    i=i+1
    if choose == 's' or choose =='S':
      print("El número de estados es: "+ x) 
    elif choose =="n" or "N":
      break
  except:
    print("ingresó datos incorrectos para elegir, es necesario que elija un número de estados")

print('Los estados son: ')
for estado in q:
  print("estado: "+ estado)

estaditos=set(q)
i=1
letras=[]

bolAux = True
while bolAux ==True:
  print('Ingrese el alfabeto separado por comas')
  simb=input()
  
  letras = simb.split(",")
  i=i+1
  print('¿Desea integrar otro simbolo?(s/n): ')
  eleccion=input()
  if eleccion == 'n' or eleccion=='N':
    bolAux=False

print('El alfabeto ingresado es: '+str(letras))
fT=[]
for j in range(0, len(q)):
  fT.append([])
  for i in range(0, len(letras)):
    print('El estado '+str(q[j])+' con el caracter '+str(letras[i])+' lleva al estado: ')
    aux=input()
    fT[j].append(aux)

funcion_transicion={}
for i in range(len(q)):
  clave=q[i]
  funcion_transicion[clave]=fT[i]

dFT={}
for i in range(len(q)):
  aux={}
  for j in range(len(letras)):
    clave=letras[j]
    aux[clave]=fT[i][j]
  clave=q[i]
  dFT[clave]=aux

clave='funcion_transicion'
diccionarioFT={clave:dFT}
alfabetillo=set(letras)

print('de la lista de estados elija el estado inicial')

inicio=input()
clave='initial_state'
diccionarioEI={clave:inicio}
print('El estado inicial es: '+inicio)

print('Por favor ingrese los estados finales ')
bolAux=True
i=1
eAceptacion=[]
while bolAux ==True:
  print('Ingrese el o los estados finales que necesita')
  simb=input()
  eAceptacion.append(simb)
  i=i+1
  print("¿Son todos los estados finales que necesitas?(s/n)")
  desicion = input()
  if desicion == "n" or desicion =="N":
    bolAux = True
  elif desicion =="s" or desicion =="S":
    bolAux = False
  else:
    print("El dato no es entendido por el programa, se procederá con la ejecución")
    break


print('Los estados finales ingresados son: '+str(eAceptacion))

edosAccept=set(eAceptacion)

dFA = VisualDFA(
    states=estaditos,
    input_symbols=alfabetillo,
    transitions=dFT,
    initial_state=inicio,
    final_states=edosAccept
)


print("ingrese una cadena para evaluar si es aceptada por el autómata")

cadena = input()

chequeada = dFA.input_check(cadena)
print(chequeada)
dFA.show_diagram()