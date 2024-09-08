﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьУсловноеОформление();
	
	Заголовок = Метаданные.Справочники.ВидыАлкогольнойПродукции.Синоним;
	ЗакрыватьПриВыборе = Ложь;
	
	ЗаполнитьКлассификатор();
	
	ОбщегоНазначенияСобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура КлассификаторВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ДобавленыНовыеЭлементыКлассификатора = Ложь;
	ВыбранныйЭлемент = КлассификаторВыборНаСервере(ВыбраннаяСтрока, ДобавленыНовыеЭлементыКлассификатора);
	Если ВыбранныйЭлемент <> Неопределено Тогда
		ОповеститьФормуИПользователяИЗакрыть(ВыбранныйЭлемент, ДобавленыНовыеЭлементыКлассификатора);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КлассификаторВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ДобавленыНовыеЭлементыКлассификатора = Ложь;
	ВыбранныйЭлемент = КлассификаторВыборНаСервере(Значение, ДобавленыНовыеЭлементыКлассификатора);
	Если ВыбранныйЭлемент <> Неопределено Тогда
		ОповеститьФормуИПользователяИЗакрыть(ВыбранныйЭлемент, ДобавленыНовыеЭлементыКлассификатора);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОповеститьФормуИПользователяИЗакрыть(ВыбранныйЭлемент, ДобавленыНовыеЭлементыКлассификатора = Ложь)
	
	Если ДобавленыНовыеЭлементыКлассификатора Тогда
		
		ОповеститьОбИзменении(Тип("СправочникСсылка.ВидыАлкогольнойПродукции"));
		
		ПоказатьОповещениеПользователя(
			НСтр("ru = 'Сохранение'"),
			,
			Заголовок,
			БиблиотекаКартинок.Информация32ГосИС);
	КонецЕсли;
	
	ОповеститьОВыборе(ВыбранныйЭлемент);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	// Классификатор
	
	ЭлементУО = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента      = ЭлементУО.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("Классификатор");
	
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"Классификатор.ЕстьСсылка", ВидСравненияКомпоновкиДанных.Равно, Истина);
	
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветФонаВыделенияПоля);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьРанееДобавленныеЭлементы()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ВидыАлкогольнойПродукции.Код КАК Код,
	|	ВидыАлкогольнойПродукции.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ВидыАлкогольнойПродукции КАК ВидыАлкогольнойПродукции";
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

&НаСервере
Процедура ЗаполнитьКлассификатор()
	
	Классификатор.Очистить();
	
	// Получаем полную таблицу элементов классификатора
	// в таблице содержатся Код, Наименование, Маркируемый.
	ТаблицаКлассификатора = Обработки.КлассификаторыЕГАИС.ВидыАлкогольнойПродукции();
	
	// Получаем таблицу элементов классификатора уже имеющихся в справочнике
	РанееДобавленныеЭлементыКлассификатора = ПолучитьРанееДобавленныеЭлементы();
	РанееДобавленныеЭлементыКлассификатора.Индексы.Добавить("Код");
	
	// Инициализируем структуру которую будем использовать для поиска существующих элементов.
	СтруктураПоискаРанееСозданных = Новый Структура();
	
	Для Каждого СтрокаТаблицы Из ТаблицаКлассификатора Цикл
		
		НоваяСтрока = Классификатор.Добавить();
		НоваяСтрока.Код          = СтрокаТаблицы.Код;
		НоваяСтрока.Маркируемый  = СтрокаТаблицы.Маркируемый;
		НоваяСтрока.Наименование = СтрокаТаблицы.Наименование;
		НоваяСтрока.ВидЛицензии  = СтрокаТаблицы.ВидЛицензии;
		
		СтруктураПоискаРанееСозданных.Вставить("Код", СтрокаТаблицы.Код);
		НайденныйЭлемент = РанееДобавленныеЭлементыКлассификатора.НайтиСтроки(СтруктураПоискаРанееСозданных);
		
		Если НайденныйЭлемент.Количество() > 0 Тогда
			НоваяСтрока.Ссылка = НайденныйЭлемент[0].Ссылка;
			НоваяСтрока.ЕстьСсылка = Истина;
		КонецЕсли;
		
	КонецЦикла;
	
	Классификатор.Сортировать("Наименование");
	
КонецПроцедуры

&НаСервере
Функция КлассификаторВыборНаСервере(Знач ВыбранныеСтроки, ДобавленыНовыеЭлементыКлассификатора = Ложь)

	МассивСсылок = Новый Массив();
	
	Если ТипЗнч(ВыбранныеСтроки) = тип("Массив") Тогда
		
		Для Каждого ИдентификаторСтроки Из ВыбранныеСтроки Цикл
			
			Элемент = Классификатор.НайтиПоИдентификатору(ИдентификаторСтроки);
			
			ДобавитьЭлементКлассификатора(Элемент, Элемент.Ссылка);
			ДобавленыНовыеЭлементыКлассификатора = Истина;
			
			МассивСсылок.Добавить(Элемент.Ссылка);
			
		КонецЦикла;
		
	ИначеЕсли ТипЗнч(ВыбранныеСтроки) = тип("Число") Тогда
		
		Элемент = Классификатор.НайтиПоИдентификатору(ВыбранныеСтроки);
		
		ДобавитьЭлементКлассификатора(Элемент, Элемент.Ссылка);
		ДобавленыНовыеЭлементыКлассификатора = Истина;
		
		МассивСсылок.Добавить(Элемент.Ссылка);
		
	КонецЕсли;

	Возврат МассивСсылок;
	
КонецФункции

&НаСервере
Процедура ДобавитьЭлементКлассификатора(ВыбраннаяСтрока, СсылкаНаЭлемент = Неопределено)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если СсылкаНаЭлемент = Неопределено Тогда
		ЭлементКлассификатора = Справочники.ВидыАлкогольнойПродукции.СоздатьЭлемент();
	Иначе
		ЭлементКлассификатора = СсылкаНаЭлемент.ПолучитьОбъект();
	КонецЕсли;
	
	ЭлементКлассификатора.Заполнить(Неопределено);
	
	ЗаполнитьЗначенияСвойств(ЭлементКлассификатора, ВыбраннаяСтрока);
	ЭлементКлассификатора.Записать();
	
	ВыбраннаяСтрока.Ссылка = ЭлементКлассификатора.Ссылка;
	ВыбраннаяСтрока.ЕстьСсылка = Истина;
	
КонецПроцедуры

#КонецОбласти