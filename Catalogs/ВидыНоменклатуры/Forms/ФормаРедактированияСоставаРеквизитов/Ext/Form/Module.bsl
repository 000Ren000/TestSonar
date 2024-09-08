﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("ФункцияОповещения") Тогда 
		ФункцияОповещения = Параметры.ФункцияОповещения;
	иначе
		ФункцияОповещения = "ПодборРеквизитовВТаблицуОтбора";
	КонецЕсли;
	
	МассивРеквизитовОтбора = ПолучитьИзВременногоХранилища(Параметры.АдресВХранилище);
	ЗаполнитьТаблицуЗначенийИзМассива(МассивРеквизитовОтбора);
	
	ТаблицаРеквизитов.Сортировать("ИмяРеквизита");

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ДобавитьВПанель(Команда)
	
	ВыполнитьПодборРеквизитов(0);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТаблицареквизитов

&НаКлиенте
Процедура ТаблицаРеквизитовПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаРеквизитовПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаРеквизитовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ВыполнитьПодборРеквизитов(2);
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаРеквизитовВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ВыполнитьПодборРеквизитов(2);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьТаблицуЗначенийИзМассива(МассивСтрок)
	
	ТаблицаРеквизитов.Очистить();
	
	Для Каждого СтрокаМассива Из МассивСтрок Цикл
		
		СтрокаТаблицыРеквизитов = ТаблицаРеквизитов.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТаблицыРеквизитов, СтрокаМассива);
		
	КонецЦикла;
	
КонецПроцедуры


// Выполнение операций по подбору и отмене подбора элементов
// 
// Параметры:
// 	ВариантПодбора - Число - Вариант подбора элементов. 0 - произвести подбор; 1 - произвести отмену подбора; 2 - инвертировать подбор
&НаКлиенте
Процедура ВыполнитьПодборРеквизитов(ВариантПодбора = 0)
	
	Если Элементы.ТаблицаРеквизитов.ВыделенныеСтроки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	МассивДобавляемых = Новый Массив;
	
	Для Каждого ВыделеннаяСтрока Из Элементы.ТаблицаРеквизитов.ВыделенныеСтроки Цикл
		
		ПараметрыСтроки = Новый Структура("ИмяРеквизита, ЭтоДопРеквизит, Свойство, Используется, ПредставлениеРеквизита, Используется");
		
		ДанныеСтроки = Элементы.ТаблицаРеквизитов.ДанныеСтроки(ВыделеннаяСтрока);
		Если ВариантПодбора = 0 Тогда			
			ДанныеСтроки.Используется = Истина;
		ИначеЕсли ВариантПодбора = 1 Тогда 
			ДанныеСтроки.Используется = Ложь;
		Иначе
			ДанныеСтроки.Используется = Не ДанныеСтроки.Используется;						
		КонецЕсли;
		
		ЗаполнитьЗначенияСвойств(ПараметрыСтроки, ДанныеСтроки);
		МассивДобавляемых.Добавить(ПараметрыСтроки);
		
	КонецЦикла;
	
	//Оповестить("ПодборРеквизитовВТаблицуОтбора", Новый Структура("МассивДобавляемых", МассивДобавляемых));
	Оповестить(ФункцияОповещения, Новый Структура("МассивДобавляемых", МассивДобавляемых));
	
КонецПроцедуры

#КонецОбласти
