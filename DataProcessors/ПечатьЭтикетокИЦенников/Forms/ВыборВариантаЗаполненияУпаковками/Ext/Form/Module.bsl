﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ИспользоватьАдресноеХранение = ПолучитьФункциональнуюОпцию("ИспользоватьАдресноеХранение");
	Если ИспользоватьАдресноеХранение Тогда
		Элементы.Вариант.СписокВыбора.Добавить("ПоСкладскойГруппе",
											НСтр("ru = 'По складской группе упаковок'"));
	КонецЕсли;
	
	Элементы.СкладскаяГруппа.Видимость = ИспользоватьАдресноеХранение;
	
	Вариант = Параметры.Вариант;
	СкладскаяГруппа = Параметры.СкладскаяГруппа;
	Если ПустаяСтрока(Вариант) Тогда
		Вариант = "Оптимально";
	КонецЕсли;
	
	УстановитьДоступностьВидимостьРеквизитов();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВариантПриИзменении(Элемент)
	УстановитьДоступностьВидимостьРеквизитов();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаполнитьУпаковки(Команда)
	
	ОчиститьСообщения();
	ОшибкаПроверки = Ложь;
	ШаблонСообщения = НСтр("ru='Поле ""%ИмяПоля%"" не заполнено.'");
	
	Если Вариант = "ПоСкладскойГруппе" Тогда
		
		Если Не ЗначениеЗаполнено(СкладскаяГруппа) Тогда
			ТекстСообщения = СтрЗаменить(ШаблонСообщения,"%ИмяПоля%",НСтр("ru = 'Складская группа'"));
			ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,,"СкладскаяГруппа");
			ОшибкаПроверки = Истина;
		КонецЕсли;
		
	КонецЕсли;
	
	Если ОшибкаПроверки Тогда
		Возврат;
	КонецЕсли;
	
	Закрыть(Новый Структура("Вариант, СкладскаяГРуппа", Вариант, СкладскаяГРуппа));
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьДоступностьВидимостьРеквизитов()
	
	Элементы.СкладскаяГруппа.Доступность = (Вариант = "ПоСкладскойГруппе");
	
КонецПроцедуры

#КонецОбласти
