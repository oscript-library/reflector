#Использовать logos
#Использовать semver
//   КартаИнтерфейса - ТаблицаЗначений - таблица значений карты проверяемого объекта, колонки:
//    * Имя                  - Строка - имя метода объекта
//    * КоличествоПараметров - Число  - число параметров в методе
//    * ЭтоФункция           - Булево - признак, что метод является функцией
Перем КартаИнтерфейса;
Перем Лог;

Перем ВерсияБольше20;

Процедура ПриСозданииОбъекта()

	КартаИнтерфейса = НоваяКартаИнтерфейса();

	Версия20 = Новый Версия("1.0.20");

	СИ = Новый СистемнаяИнформация;
	ТекущаяВерсия = Новый Версия(СИ.Версия);
	ВерсияБольше20 = ТекущаяВерсия.БольшеИлиРавны(Версия20);

КонецПроцедуры

// Проверяет переданную карту класса на реализацию текущего интерфейса
//
// Параметры:
//   КартаКласса - ТаблицаЗначений - таблица значений карты проверяемого объекта, колонки:
//    * Имя                  - Строка - имя метода объекта
//    * КоличествоПараметров - Число  - число параметров в методе
//    * ЭтоФункция           - Булево - признак, что метод является функцией
//   СообщитьОшибки - Булево - признак. вывода ошибки (по умолчанию Истина)
//
//  Возвращаемое значение:
//   Булево - Истина, если интерфейс реализован в переданной карте класса
//
Функция Реализован(КартаКласса, СообщитьОшибки = Истина) Экспорт

	ИнтерфейсРеализован = Истина;
	ОшибкиРеализации = "";
	Для каждого Элемент Из КартаИнтерфейса Цикл

		НайденныйЭлемент = КартаКласса.Найти(Элемент.Имя, "Имя");
		Если НайденныйЭлемент = Неопределено Тогда
			ИнтерфейсРеализован = Ложь;
			ОшибкиРеализации  = ОшибкиРеализации + Символы.ВК + Символы.ПС + "Не реализован метод интерфейса " + Элемент.Имя;
			Продолжить;
		КонецЕсли;

		ПроверкаНаКоличествоПараметров = Элемент.КоличествоПараметров = НайденныйЭлемент.КоличествоПараметров;

		Если ВерсияБольше20 Тогда

			ТаблицаПараметров = НайденныйЭлемент.Параметры;
			ПроверкаНаКоличествоПараметров = ПроверитьКоличествоПараметров(ТаблицаПараметров,
																		   Элемент.КоличествоПараметров);
		КонецЕсли;

		Если НЕ ПроверкаНаКоличествоПараметров Тогда
			ОшибкиРеализации = ОшибкиРеализации + Символы.ВК + Символы.ПС + 
			СтрШаблон("Неверное количество параметров у метода <%1> , есть: <%2>  должно быть: <%3>", 
			Элемент.Имя, НайденныйЭлемент.КоличествоПараметров, Элемент.КоличествоПараметров);
		КонецЕсли;

	КонецЦикла;

	Если Не ИнтерфейсРеализован
		И СообщитьОшибки Тогда
		Лог.Ошибка(ОшибкиРеализации);
	КонецЕсли;

	Возврат ИнтерфейсРеализован;

КонецФункции

// Возвращает реализованные методы согласно интерфейсу класса
//
// Параметры:
//   КартаКласса - ТаблицаЗначений - таблица значений карты проверяемого объекта, колонки:
//    * Имя                  - Строка - имя метода объекта
//    * КоличествоПараметров - Число  - число параметров в методе
//    * ЭтоФункция           - Булево - признак, что метод является функцией
//
//  Возвращаемое значение:
//   Структура - набор методов класса с признаком реализации
//    * Ключ - Строка - имя метода
//    * Значение - Булево - Истина, есть метод реализован, иначе Ложь
//
Функция РеализованныеМетоды(КартаКласса) Экспорт

	ИндексМетодов = Новый Структура;

	Для каждого Элемент Из КартаИнтерфейса Цикл

		НайденныйЭлемент = КартаКласса.Найти(Элемент.Имя, "Имя");
		Если НайденныйЭлемент = Неопределено Тогда
			ИндексМетодов.Вставить(Элемент.Имя, Ложь);
			Продолжить;
		КонецЕсли;
		Если НайденныйЭлемент.КоличествоПараметров <> Элемент.КоличествоПараметров Тогда
			ИндексМетодов.Вставить(Элемент.Имя, Ложь);
			Продолжить;
		КонецЕсли;

		ИндексМетодов.Вставить(Элемент.Имя, Истина);

	КонецЦикла;

	Возврат ИндексМетодов;

КонецФункции

// Заполняет карту интерфейса из произвольного объекта
//
// Параметры:
//   ОбъектИнтерфейса - произвольный - произвольны объект для получения его карты интерфейса
//
Процедура ИзОбъекта(ОбъектИнтерфейса) Экспорт

	Рефлектор = Новый Рефлектор;
	КартаИнтерфейса = Рефлектор.ПолучитьТаблицуМетодов(ОбъектИнтерфейса);

КонецПроцедуры

// Заполняет карту интерфейса из произвольного объекта исключая часть методов
//
// Параметры:
//   ОбъектИнтерфейса - произвольный - произвольны объект для получения его карты интерфейса
//   МассивМетодовИсключения - Строка, Массив - набор методов для исключения при создании
//
Процедура ИзОбъектаИсключая(ОбъектИнтерфейса, Знач МассивМетодовИсключения) Экспорт

	Если ТипЗнч(МассивМетодовИсключения) = Тип("Строка") Тогда
		МассивМетодовИсключения = СтрРазделить(МассивМетодовИсключения, " ", Ложь);
	КонецЕсли;

	Рефлектор = Новый Рефлектор;
	КартаИнтерфейса = Рефлектор.ПолучитьТаблицуМетодов(ОбъектИнтерфейса);

	Для каждого ИмяМетодаИсключения Из МассивМетодовИсключения Цикл
		
		УдалитьМетод(ИмяМетодаИсключения);

	КонецЦикла;

КонецПроцедуры

// Заполняет карту интерфейса из другого интерфейса
//
// Параметры:
//   ВходящийИнтерфейс - Объект.ИнтерфейсОбъекта - ссылка на экземпляр класса ИнтерфейсОбъекта
//   Заменить - Булево - признак полной замены текущей карты интерфейса (по умолчанию истина)
//
Процедура ИзИнтерфейса(ВходящийИнтерфейс, Заменить = Истина) Экспорт

	КартаИнтерфейсаВходящего = ВходящийИнтерфейс.ПолучитьКартуИнтерфейса();

	Если Заменить Тогда
		КартаИнтерфейса = НоваяКартаИнтерфейса();
	КонецЕсли;

	Для каждого СтрокаИнтерфейса Из КартаИнтерфейсаВходящего Цикл

		ДобавитьМетод(СтрокаИнтерфейса.Имя, СтрокаИнтерфейса.КоличествоПараметров, СтрокаИнтерфейса.ЭтоФункция);

	КонецЦикла;

КонецПроцедуры

// Возвращает текущую карту интерфейса
//
//  Возвращаемое значение:
//   ТаблицаЗначений - таблица значений карты интерфейса, колонки:
//    * Имя                  - Строка - имя метода объекта
//    * КоличествоПараметров - Число  - число параметров в методе
//    * ЭтоФункция           - Булево - признак, что метод является функцией
//
Функция ПолучитьКартуИнтерфейса() Экспорт

	Возврат КартаИнтерфейса;

КонецФункции

// Удаляет процедуру или функцию в интерфейсе
//
// Параметры:
//   ИмяМетода - Строка - имя процедуры интерфейса
//
//  Возвращаемое значение:
//   Объект.ИнтерфейсОбъекта - ссылка на текущий экземпляр класса
//
Функция УдалитьМетод(Знач ИмяМетода) Экспорт
	
	НайденныйЭлемент = КартаИнтерфейса.Найти(ИмяМетода, "Имя");

	Если Не НайденныйЭлемент = Неопределено Тогда
		КартаИнтерфейса.Удалить(НайденныйЭлемент);
	КонецЕсли;

	Возврат ЭтотОбъект;

КонецФункции

// Добавляет процедуру в интерфейс
//
// Параметры:
//   ИмяМетода - Строка - имя процедуры интерфейса
//   КоличествоПараметров - Число - количество параметров процедуры
//
//  Возвращаемое значение:
//   Объект.ИнтерфейсОбъекта - ссылка на текущий экземпляр класса
//
Функция ПроцедураИнтерфейса(ИмяМетода, КоличествоПараметров = 0) Экспорт

	ДобавитьМетод(ИмяМетода, КоличествоПараметров, Ложь);

	Возврат ЭтотОбъект;

КонецФункции

// Добавляет функцию в интерфейс
//
// Параметры:
//   ИмяМетода - Строка - имя функции интерфейса
//   КоличествоПараметров - Число - количество параметров функции
//
//  Возвращаемое значение:
//   Объект.ИнтерфейсОбъекта - ссылка на текущий экземпляр класса
//
Функция ФункцияИнтерфейса(ИмяМетода, КоличествоПараметров = 0) Экспорт

	ДобавитьМетод(ИмяМетода, КоличествоПараметров, Истина);

	Возврат ЭтотОбъект;

КонецФункции

// (Кратное название функции ПроцедурыИнтерфейса)
// Добавляет процедуру в интерфейс
//
// Параметры:
//   ИмяМетода - Строка - имя процедуры интерфейса
//   КоличествоПараметров - Число - количество параметров процедуры
//
//  Возвращаемое значение:
//   Объект.ИнтерфейсОбъекта - ссылка на текущий экземпляр класса
//
Функция П(ИмяМетода, КоличествоПараметров = 0) Экспорт

	ПроцедураИнтерфейса(ИмяМетода, КоличествоПараметров);

	Возврат ЭтотОбъект;

КонецФункции

// (Кратное название функции ФункцияИнтерфейса)
// Добавляет функцию в интерфейс
//
// Параметры:
//   ИмяМетода - Строка - имя функции интерфейса
//   КоличествоПараметров - Число - количество параметров функции
//
//  Возвращаемое значение:
//   Объект.ИнтерфейсОбъекта - ссылка на текущий экземпляр класса
//
Функция Ф(ИмяМетода, КоличествоПараметров = 0) Экспорт

	ФункцияИнтерфейса(ИмяМетода, КоличествоПараметров);

	Возврат ЭтотОбъект;

КонецФункции

Функция НоваяКартаИнтерфейса()

	ТаблицаМетодов = Новый ТаблицаЗначений;
	ТаблицаМетодов.Колонки.Добавить("Имя");
	ТаблицаМетодов.Колонки.Добавить("КоличествоПараметров");
	ТаблицаМетодов.Колонки.Добавить("ЭтоФункция");

	Возврат ТаблицаМетодов;

КонецФункции

Функция ПроверитьКоличествоПараметров(ТаблицаПараметров, ТребуемоеКоличествоПараметров)

	ВсегоПараметров = ТаблицаПараметров.Количество();

	Если ВсегоПараметров = ТребуемоеКоличествоПараметров Тогда
		Возврат Истина;
	ИначеЕсли ТребуемоеКоличествоПараметров > ВсегоПараметров Тогда
		Возврат Ложь;
	КонецЕсли;

	ВсегоПараметров = ТаблицаПараметров.Количество();
	КоличествоПараметровНеобязательных = 0;

	Для каждого СтрокаПараметра Из ТаблицаПараметров Цикл
		Если СтрокаПараметра.ЕстьЗначениеПоУмолчанию Тогда
			КоличествоПараметровНеобязательных = КоличествоПараметровНеобязательных + 1;
		КонецЕсли;
	КонецЦикла;

	КоличествоПараметровОбязательных = ВсегоПараметров - КоличествоПараметровНеобязательных;

	Возврат ТребуемоеКоличествоПараметров >= КоличествоПараметровОбязательных
			И ТребуемоеКоличествоПараметров <= ВсегоПараметров;

КонецФункции

Процедура ДобавитьМетод(ИмяМетода, КоличествоПараметров = 0, ЭтоФункция = Ложь)

	Отбор = Новый Структура("Имя", ИмяМетода);

	МассивСтрокМетода = КартаИнтерфейса.НайтиСтроки(Отбор);

	Если МассивСтрокМетода.Количество() = 0 Тогда
		СтрокаМетода = КартаИнтерфейса.Добавить();
		СтрокаМетода.Имя = ИмяМетода;
	Иначе
		СтрокаМетода = МассивСтрокМетода[0];
	КонецЕсли;

	СтрокаМетода.КоличествоПараметров = КоличествоПараметров;
	СтрокаМетода.ЭтоФункция = ЭтоФункция;

КонецПроцедуры

Лог = Логирование.ПолучитьЛог("oscript.lib.reflector");
