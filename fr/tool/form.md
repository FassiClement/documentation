# Formulaire

Le système de formulaire de Beluga permet aux développeurs d'analyser automatiquement les données reçues au travers des méthodes GET et POST.

## Implémentation

### Formulaire basique

Imaginez un simple formulaire demandant un __nom__, un __âge__ et un __genre__ optionnel. Encapsulons celui-ci au sein d'un objet Haxe:

```Haxe
class MyFrom
{
  public var name : String;
  public var age : Int;
  public var genre : Null<String>;
}
```

###### Notes

Seuls les types basiques suivant sont reconnus:
* Int
* Float
* String
* Bool

Vous pouvez faire un ou plusieurs parametres optionnel en spécifiant que son type est `Null<T>`.

### Définir des exigences

Maintenant que nous avons notre formulaire, nous devons définir les exigences (ou règles) que nos données doivent valider. Pour celam notre formulaire doit hériter de `beluga.form.Object` puis, préfixer chaque variable avec des métadonnées.

```Haxe
class MyFrom extends beluga.form.Object
{
  @MinLength(4)
  @MaxLength(32)
  public var name : String;

  @RangeValue(0, 120)
  @Match(Pattern.Number)
  public var age : Int;

  @Match(Pattern.Alpha)
  public var genre : Null<String>;
}
```

###### Liste des exigences

* MinValue(x): La valeur doit être supérieure ou égale à x
* MaxValue(x): La valeur doit être inférieure ou égale à x
* RangeValue(x, y): Raccourcie pour MinValue(x) et MaxValue(y)
* EqualValue(value): La valeur doit être égale à la valeur donnée 
* MinLength(x): La taille de la valeur doit être au minimum de x
* MaxLength(x): La taille de la valeur doit être au maximum de x
* RangeLength(x, y): Raccourcie MinLength(x) et MaxLength(y)
* EqualLength(x): La taille de la valeur doit être de x exactement
* Match(pattern): La valeur doit correspondre au schéma donné
* EqualTo(field): La valeur doit être égale à la valeur du champ indiqué
* Database(table, field): Le champ doit correspondre au moins à une valeur dans la base de données *En développement*
* Alter(function): La valeur est altérée par la fonction donnée. La valeur originale est perdue. Cette règle retourne toujours `true`.

###### Liste des schémas prédéfinis *(En développement)*

* Number: Match number.
* Alpha: Match alphabetic characters.
* AlphaNumeric: Match alpha-numeric character. Combinaison of Number and Alpha.
* Email: Match e-mail address.
* Date: Match date format.
* Time: Match time format.
* DateTime: Match date and time format. Cominaison of Date andTime.
* Month: Match month format.
* Week: Match week format.
* Phone: Match phone format.
* Color: Match color format.
* URL: Match URL format.
* Expr(expr): Custom pattern.

### Processus de validation

À partir d'ici, nous avons définie notre forulaire et ses exigences donc, maintenant, il est temps de parler de leur validation. En réalité, c'est trés simple. Premièrement, vous devez créer votre objet de formulaire en passant une strucutre anonyme comme paramètre. Cela évite d'assigner le contenu de la structure manuellement bien que possible. Une fois effectué, vous n'avez plus qu'à appeler la fonction `validate`. Si une erreur survient, alors vous pourrez y accéder au traver de la variable publique `error`; qui est un type `Map` avec le nom de la variable en tant que clé et le nom de l'exigence comme valeur.

```Haxe
class MyFrom extends beluga.form.Object
{
  @MinLength(4)
  @MaxLength(32)
  public var name : String;

  @RangeValue(0, 120)
  @Match(Pattern.Number)
  public var age : Int;

  @Match(Pattern.Alpha)
  public var genre : Null<String>;
}

// ...

public function doSomething(args : {name : String, age : Int, genre : Null<String>})
{
  // Init the form object with form data
  var my_form = new MyForm(args);

  // Check correctness of data
  var is_correct = my_form.validate();
  if (is_correct == true)
  {
    // No error! Yippee-Ki Yay \o/
  }
  else
  {
    trace(my_form.error);
  }
}
```

## Limitations

Il nous manque un système qui peut automatiquement lié le système d'erreurs de Beluga pour valider le processus. Nous avons encore besoin de le faire nous-même en créant de gigantesque déclaration de `if/else`. Cela DOIT changer.