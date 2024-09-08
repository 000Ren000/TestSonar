﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ДатаНачала = Дата(1,1,1);
	ДокументОснование = Документы.РеализацияТоваровУслуг.ПустаяСсылка();
	АдресХранилища = "";
		
	Если Параметры.Свойство("Отбор") Тогда
		Параметры.Отбор.Свойство("ДокументОснование", ДокументОснование);
		Параметры.Отбор.Свойство("ДатаНачала", 		  ДатаНачала);
		Параметры.Отбор.Свойство("АдресХранилища", 	  АдресХранилища);
	КонецЕсли;
	
	Список.Параметры.УстановитьЗначениеПараметра("ДокументСсылка", ДокументОснование);
	Список.Параметры.УстановитьЗначениеПараметра("ДокументСсылкаНеЗаполнен", Не ЗначениеЗаполнено(ДокументОснование));
	
	Если Не ПустаяСтрока(АдресХранилища) Тогда 
		
		ТаблицаПараметровОтбора = ПолучитьИзВременногоХранилища(АдресХранилища);
		
		ОтборДинамическогоСписка = Список.КомпоновщикНастроек.Настройки.Отбор;
		ГруппаИли = ОбщегоНазначенияКлиентСервер.СоздатьГруппуЭлементовОтбора(ОтборДинамическогоСписка.Элементы, "ГруппаИли", ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли);
		
		Для Каждого ПараметрыОтбора Из ТаблицаПараметровОтбора Цикл
			ГруппаИ = ОбщегоНазначенияКлиентСервер.СоздатьГруппуЭлементовОтбора(ГруппаИли.Элементы, "ГруппаИ", ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ);
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
					ГруппаИ, "АдресДоставки", ПараметрыОтбора.АдресДоставки, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(ПараметрыОтбора.АдресДоставки));
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
					ГруппаИ, "Грузополучатель", ПараметрыОтбора.Грузополучатель, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(ПараметрыОтбора.Грузополучатель));
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
					ГруппаИ, "Организация", ПараметрыОтбора.Организация, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(ПараметрыОтбора.Организация));
					
			Перевозчик = ПартнерыИКонтрагенты.ПолучитьКонтрагентаПартнераПоУмолчанию(ПараметрыОтбора.ПеревозчикПартнер);		
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
					ГруппаИ, "Перевозчик", Перевозчик, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(Перевозчик));
		КонецЦикла;
		
	КонецЕсли;	
					
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
					Список, "Дата", ДатаНачала, ВидСравненияКомпоновкиДанных.БольшеИлиРавно);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ИнтеграцияС1СДокументооборотом
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#Область ОбработчикиКомандФормы

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Элементы.Список);
	
КонецПроцедуры
// Конец ИнтеграцияС1СДокументооборотом

#КонецОбласти
