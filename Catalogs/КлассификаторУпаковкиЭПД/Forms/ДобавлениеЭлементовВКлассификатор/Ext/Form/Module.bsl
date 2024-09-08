﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();

	ИмяСправочника = "КлассификаторУпаковкиЭПД";
	
	Элементы.Классификатор.МножественныйВыбор = Истина;
	ЗакрыватьПриВыборе = Ложь;
		
	ИнициализироватьКлассификатор();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицыФормыКлассификатор

//Вызывается при двойном щелчке мыши или нажатии Enter
//
&НаКлиенте
Процедура КлассификаторВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ДобавленыНовыеЭлементыКлассификатора = Ложь;
	ВыбранныйЭлемент = КлассификаторВыборНаСервере(ВыбраннаяСтрока, ДобавленыНовыеЭлементыКлассификатора);
	Если ВыбранныйЭлемент <> Неопределено Тогда
		ОповеститьФормуИПользователяИЗакрыть(ВыбранныйЭлемент, ДобавленыНовыеЭлементыКлассификатора);
	КонецЕсли;
	
КонецПроцедуры

//Вызывается при нажатии на кнопку выбрать
//
&НаКлиенте
Процедура КлассификаторВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ДобавленыНовыеЭлементыКлассификатора = Ложь;
	ВыбранныйЭлемент = КлассификаторВыборНаСервере(Значение, ДобавленыНовыеЭлементыКлассификатора);
	Если ВыбранныйЭлемент <> Неопределено Тогда
		ОповеститьФормуИПользователяИЗакрыть(ВыбранныйЭлемент, ДобавленыНовыеЭлементыКлассификатора);
	КонецЕсли;
	
КонецПроцедуры

//Функция обрабатывает данные выбора пользователя
//
//В случае если выбранные элементы классификатора отсутстуют в справочнике
// они будут добавлены.
//
//Если был осуществлен множественный выбор, то все выбранные элементы будут обработаны
// (добавлены в справочник в случае отсутствия), в возвращаемый параметр, будет передан
// массив ссылок на элементы
//
// Параметры:
// ВыбранныеСтроки - Массив, массив выбранных строк таблицы формы классификатор
// ДобавленыНовыеЭлементыКлассификатора - Булево, флаг устанавливается 
// 	если в справочник были добавлены элементы
//
// Возвращаемое значение:
// Неопределено или СправочникСсылка: 
// 		КлассификаторВидовЭкономическойДеятельности 
// 		или  КлассификаторПродукцииПоВидамДеятельности 
//		или КлассификаторУслугНаселению
//
&НаСервере
Функция КлассификаторВыборНаСервере(Знач ВыбранныеСтроки, ДобавленыНовыеЭлементыКлассификатора = Ложь)

	СсылкаНаЭлемент = Неопределено;
	
	МассивСсылок = Новый Массив();
	
	Если ТипЗнч(ВыбранныеСтроки) = Тип("Массив") Тогда
		
		Для Каждого ИдентификаторСтроки из ВыбранныеСтроки Цикл
			
			Элемент = Классификатор.НайтиПоИдентификатору(ИдентификаторСтроки);
			
			Если НЕ ЗначениеЗаполнено(Элемент.Ссылка) Тогда
				
				ДобавитьЭлементКлассификатора(Элемент);
				ДобавленыНовыеЭлементыКлассификатора = Истина;
				
			КонецЕсли;
			
			МассивСсылок.Добавить(Элемент.Ссылка);
			СсылкаНаЭлемент = Элемент.Ссылка;
			
		КонецЦикла;
		
	ИначеЕсли ТипЗнч(ВыбранныеСтроки) = Тип("Число") Тогда
		
		Элемент = Классификатор.НайтиПоИдентификатору(ВыбранныеСтроки);
		
		Если НЕ ЗначениеЗаполнено(Элемент.Ссылка) Тогда
			
			ДобавитьЭлементКлассификатора(Элемент);
			ДобавленыНовыеЭлементыКлассификатора = Истина;
			
		КонецЕсли;
		
		МассивСсылок.Добавить(Элемент.Ссылка);
		СсылкаНаЭлемент = Элемент.Ссылка;
		
	КонецЕсли;

	Если Подбор Тогда
		Возврат МассивСсылок;
	Иначе	
		Возврат СсылкаНаЭлемент;
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();

	// Классификатор

	ЭлементУО = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента 		= ЭлементУО.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле 	= Новый ПолеКомпоновкиДанных("Классификатор");

	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"Классификатор.ЕстьСсылка", ВидСравненияКомпоновкиДанных.Равно, Истина);

	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветФонаВыделенияПоля);

КонецПроцедуры

&НаСервере
Функция ПолучитьРанееДобавленныеЭлементы()
	
	Запрос = Новый Запрос;
	ЗапросТекст = 
	"ВЫБРАТЬ
	|	%1.Код,
	|	%1.Ссылка
	|ИЗ
	|	Справочник.%1 КАК %1";

	Запрос.Текст = СтрЗаменить(ЗапросТекст, "%1", ИмяСправочника);
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

&НаСервере
Функция ПолучитьЗначенияКлассификатораИзМакета()
	
	ТаблицаПоказателей = Справочники.КлассификаторУпаковкиЭПД.ТаблицаКлассификатораУпаковки();
	Возврат ТаблицаПоказателей;
	
КонецФункции

// Заполняет классификатор данными
//
&НаСервере
Процедура ЗаполнитьКлассификатор()
	
	Классификатор.Очистить();
	
	// Получаем полную таблицу элементов классификатора
	// в таблице содержатся Код и Наименование, элементов классификатора.
	ЭлементыКлассификатораИзМакета = ПолучитьЗначенияКлассификатораИзМакета();
	
	// Получаем таблицу элементов классификатора уже имеющихся в справочнике.
	РанееДобавленныеЭлементыКлассификатора = ПолучитьРанееДобавленныеЭлементы();
	РанееДобавленныеЭлементыКлассификатора.Индексы.Добавить("Код");
	
	ЭлементыКлассификатора = ЭлементыКлассификатораИзМакета;
	
	Если ЭлементыКлассификатора.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	// Инициализируем структуру которую будем использовать для поиска существующих элементов.
	СтруктураПоискаРанееСозданных = Новый Структура();
	
	Для Каждого Элемент Из ЭлементыКлассификатора Цикл
		
		НоваяСтрока = Классификатор.Добавить();
		НоваяСтрока.Код              			= Элемент.Код;
		НоваяСтрока.Наименование    			= Элемент.Наименование;
		НоваяСтрока.НаименованиеНаАнглийском 	= Элемент.НаименованиеНаАнглийском;
		
		СтруктураПоискаРанееСозданных.Вставить("Код", Элемент.Код);
		НайденныйЭлемент = РанееДобавленныеЭлементыКлассификатора.НайтиСтроки(СтруктураПоискаРанееСозданных);
		
		Если НайденныйЭлемент.Количество() > 0 Тогда
			
			НоваяСтрока.Ссылка = НайденныйЭлемент[0].Ссылка;
			НоваяСтрока.ЕстьСсылка = Истина;
			
		КонецЕсли;
		
	КонецЦикла;
		
	Классификатор.Сортировать("ЕстьСсылка Убыв, Код Возр");
		
КонецПроцедуры

// Добавляет новый элемент в классификатор
// Параметры:
// - ВыбраннаяСтрока - Строка таблицы, источник данных для заполнения реквизитов классификатораъ
// 		Если в строке присутсвуют данные о единице измерения, 
//		запускается поиск и добавление единицы измерения
//
&НаСервере
Процедура ДобавитьЭлементКлассификатора(ВыбраннаяСтрока)
	
	ЭлементКлассификатора = Справочники[ИмяСправочника].СоздатьЭлемент();
	ЗаполнитьЗначенияСвойств(ЭлементКлассификатора, ВыбраннаяСтрока);
	
	ЭлементКлассификатора.Записать();
	ВыбраннаяСтрока.Ссылка = ЭлементКлассификатора.Ссылка;
	
КонецПроцедуры
	
// Вызывает оповещение об изменении справочника
// вызывает оповещение пользователя
// закрывает форму подбора из классификатора
//
&НаКлиенте
Процедура ОповеститьФормуИПользователяИЗакрыть(ВыбранныйЭлемент, ДобавленыНовыеЭлементыКлассификатора = Ложь)
	
	Если ДобавленыНовыеЭлементыКлассификатора Тогда
		
		ОповеститьОбИзменении(Тип("СправочникСсылка." + ИмяСправочника));
		
		ПоказатьОповещениеПользователя(
			НСтр("ru = 'Сохранение'"),
			,
			ЭтаФорма.Заголовок,
			БиблиотекаКартинок.Информация32);
	КонецЕсли;
	
	ОповеститьОВыборе(ВыбранныйЭлемент);
	
КонецПроцедуры

&НаСервере
Процедура ИнициализироватьКлассификатор()
	
	ЗаполнитьКлассификатор();
	
КонецПроцедуры

#КонецОбласти