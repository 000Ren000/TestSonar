﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Статья = Параметры.ЗначениеПоУмолчанию;
	Элементы.Статья.ПараметрыВыбора = Параметры.ПараметрыВыбораЭлементаСтатьи;
	
	ПараметрыВыбора = ДоходыИРасходыСервер.ПараметрыВыбораСтатьиИАналитики();
	ПараметрыВыбора.ПутьКДанным = "";
	ПараметрыВыбора.Статья = "Статья";
	ПараметрыВыбора.ТипСтатьи = "ТипСтатьи";
	ПараметрыВыбора.ЗначениеПоУмолчанию = Параметры.ЗначениеПоУмолчанию;
	
	ПараметрыВыбора.ВыборСтатьиРасходов = Параметры.ВыборСтатьиРасходов;
	ПараметрыВыбора.АналитикаРасходов = "АналитикаРасходов";
	ПараметрыВыбора.ВыборСтатьиДоходов  = Параметры.ВыборСтатьиДоходов;
	ПараметрыВыбора.АналитикаДоходов = "АналитикаДоходов";
	ПараметрыВыбора.ВыборСтатьиАктивовПассивов = Параметры.ВыборСтатьиАктивовПассивов;
	ПараметрыВыбора.АналитикаАктивовПассивов = "АналитикаАктивовПассивов";
	
	ПараметрыВыбора.ЭлементыФормы.Статья.Добавить("Статья");
	ПараметрыВыбора.ЭлементыФормы.АналитикаРасходов.Добавить("АналитикаРасходов");
	ПараметрыВыбора.ЭлементыФормы.АналитикаДоходов.Добавить("АналитикаДоходов");
	ПараметрыВыбора.ЭлементыФормы.АналитикаАктивовПассивов.Добавить("АналитикаАктивовПассивов");
	
	ДоходыИРасходыСервер.ПриСозданииНаСервере(ЭтаФорма, ПараметрыВыбора);
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СтатьяНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ДоходыИРасходыКлиент.НачалоВыбораСтатьи(ЭтаФорма, Элемент, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура СтатьяПриИзменении(Элемент)
	ДоходыИРасходыКлиентСервер.СтатьяПриИзменении(ЭтаФорма, Элемент);
КонецПроцедуры

&НаКлиенте
Процедура АналитикаРасходовПриИзменении(Элемент)
	ДоходыИРасходыКлиентСервер.АналитикаРасходовПриИзменении(ЭтаФорма, Элемент);
КонецПроцедуры

&НаКлиенте
Процедура АналитикаДоходовПриИзменении(Элемент)
	ДоходыИРасходыКлиентСервер.АналитикаДоходовПриИзменении(ЭтаФорма, Элемент);
КонецПроцедуры

&НаКлиенте
Процедура АналитикаАктивовПассивовПриИзменении(Элемент)
	ДоходыИРасходыКлиентСервер.АналитикаАктивовПассивовПриИзменении(ЭтаФорма, Элемент);
КонецПроцедуры

&НаКлиенте
Процедура АналитикаРасходовНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ДоходыИРасходыКлиент.НачалоВыбораАналитикиРасходов(ЭтаФорма, Элемент, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура АналитикаРасходовАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	ДоходыИРасходыКлиент.АвтоПодборАналитикиРасходов(ЭтаФорма, Элемент, Текст, ДанныеВыбора, Параметры, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура АналитикаРасходовОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	ДоходыИРасходыКлиент.ОкончаниеВводаТекстаАналитикиРасходов(ЭтаФорма, Элемент, Текст, ДанныеВыбора, Параметры, СтандартнаяОбработка);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКоманд

&НаКлиенте
Процедура Выбрать(Команда)
	
	ОчиститьСообщения();
	
	Если ПроверитьЗаполнение() Тогда
		Результат = Новый Структура();
		Результат.Вставить("Статья", Статья);
		Результат.Вставить("АналитикаРасходов",        АналитикаРасходов);
		Результат.Вставить("АналитикаДоходов",         АналитикаДоходов);
		Результат.Вставить("АналитикаАктивовПассивов", АналитикаАктивовПассивов);
		ОповеститьОВыборе(Результат);
	КонецЕсли;
	
КонецПроцедуры


#КонецОбласти

