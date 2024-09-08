﻿#Область ОписаниеПеременных

&НаКлиенте
Перем ИмяРедактируемогоРеквизита;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	// Заполним значения реквизитов
	ИсходныеПараметры = Новый Структура;
	
	РеквизитыФормы = ПолучитьРеквизиты();
	Для Каждого РеквизитФормы Из РеквизитыФормы Цикл 
		Если Параметры.Свойство(РеквизитФормы.Имя) Тогда
			ЭтаФорма[РеквизитФормы.Имя] = Параметры[РеквизитФормы.Имя];
			ИсходныеПараметры.Вставить(РеквизитФормы.Имя, Параметры[РеквизитФормы.Имя]);
		КонецЕсли;
	КонецЦикла;
	
	Если РеквизитыБанкаДляРасчетов Тогда
		Заголовок = НСтр("ru= 'Реквизиты банка для расчетов'") 
	Иначе
		Заголовок = НСтр("ru= 'Реквизиты банка'") 
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(РезультатВыбора, ИсточникВыбора)
	Если Не (ИсточникВыбора.ИмяФормы = "Справочник.БанковскиеСчетаОрганизаций.Форма.РеквизитыБанка"
		Или ИсточникВыбора.ИмяФормы = "Справочник.КлассификаторБанков.Форма.ФормаВыбора") Тогда
		Возврат;
	КонецЕсли;
	
	Если (ИсточникВыбора.ИмяФормы = "Справочник.БанковскиеСчетаОрганизаций.Форма.РеквизитыБанка") Тогда
		Если Не ПустаяСтрока(РезультатВыбора) Тогда
			Если РезультатВыбора.Реквизит = "БИКБанка" Тогда
				РучноеИзменениеРеквизитовБанка = РезультатВыбора.РучноеИзменение;
				БИКБанка			 = РезультатВыбора.ЗначенияПолей.БИК;
				НаименованиеБанка = РезультатВыбора.ЗначенияПолей.Наименование;
				КоррСчетБанка	 = РезультатВыбора.ЗначенияПолей.КоррСчет;
				ГородБанка		 = РезультатВыбора.ЗначенияПолей.Город;
				Если РезультатВыбора.РучноеИзменение Тогда
					Банк				 = "";
				Иначе
					Банк				 = РезультатВыбора.Банк;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	ИначеЕсли (ИсточникВыбора.ИмяФормы = "Справочник.КлассификаторБанков.Форма.ФормаВыбора") Тогда	
		Если ТипЗнч(РезультатВыбора) = Тип("СправочникСсылка.КлассификаторБанков") Тогда
			Если ИмяРедактируемогоРеквизита = "БИКБанка" Тогда
				Банк				 = РезультатВыбора;
				ЗаполнитьРеквизитыБанкаПоБанку(РезультатВыбора, "Банк", Ложь);
			КонецЕсли;	
		КонецЕсли;	
	КонецЕсли;
	
	Если Окно <> Неопределено Тогда
		Окно.Активизировать();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура БИКБанкаПриИзменении(Элемент)
	ИмяРедактируемогоРеквизита = Элемент.Имя;
	РеквизитБанкаПриИзменении(Элемент.Имя);
КонецПроцедуры

&НаКлиенте
Процедура БИКБанкаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ИмяРедактируемогоРеквизита = Элемент.Имя;
	РеквизитБанкаПриВыборе(Элемент.Имя, ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура БИКБанкаОткрытие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ИмяРедактируемогоРеквизита = Элемент.Имя;
	РеквизитБанкаОткрытие(Элемент.Имя);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗавершитьРедактирование(Команда)
	ПараметрыЗакрытия = Новый Структура("
		|Банк, 
		|БИКБанка, 
		|ГородБанка, 
		|КоррСчетБанка, 
		|НаименованиеБанка, 
		|РучноеИзменениеРеквизитовБанка");
		
	ЗаполнитьЗначенияСвойств(ПараметрыЗакрытия, ЭтаФорма);
	
	Если Не(ИсходныеПараметры.Банк.Пустая()
		И ПустаяСтрока(ИсходныеПараметры.БИКБанка)
		И ПустаяСтрока(ИсходныеПараметры.ГородБанка)
		И ПустаяСтрока(ИсходныеПараметры.КоррСчетБанка)
		И ПустаяСтрока(ИсходныеПараметры.НаименованиеБанка))
		И 
		Не(ИсходныеПараметры.Банк = ПараметрыЗакрытия.Банк
		И ИсходныеПараметры.БИКБанка = ПараметрыЗакрытия.БИКБанка
		И ИсходныеПараметры.ГородБанка = ПараметрыЗакрытия.ГородБанка
		И ИсходныеПараметры.КоррСчетБанка = ПараметрыЗакрытия.КоррСчетБанка
		И ИсходныеПараметры.НаименованиеБанка = ПараметрыЗакрытия.НаименованиеБанка) Тогда
		ПараметрыЗакрытия.РучноеИзменениеРеквизитовБанка = Истина;
	КонецЕсли;
	
	Закрыть(ПараметрыЗакрытия);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ПриИзмененииРеквизитов

&НаКлиенте
Процедура РеквизитБанкаПриИзменении(ИмяЭлемента)

	Если (ИмяЭлемента = "БИКБанка") Тогда
			Если Не ЗаполнитьРеквизитыБанкаПоБИК(БИКБанка, "Банк", Истина) Тогда
				СписокВариантовОтветовНаВопрос = Новый СписокЗначений;
				СписокВариантовОтветовНаВопрос.Добавить("ВыбратьИзСписка", НСтр("ru='Выбрать из списка'"));
				СписокВариантовОтветовНаВопрос.Добавить("ПродолжитьВвод",  НСтр("ru='Продолжить ввод'"));
				СписокВариантовОтветовНаВопрос.Добавить("ОтменитьВвод",	   НСтр("ru='Отменить ввод'"));
				
				ТекстВопроса = НСтр("ru = 'Банк с БИК  %Значение% не найден в классификаторе банков.'");
				ТекстВопроса = СтрЗаменить(ТекстВопроса,"%Значение%",БИКБанка);
				
				Ответ = Неопределено;

				
				ПоказатьВопрос(Новый ОписаниеОповещения("РеквизитБанкаПриИзмененииЗавершение", ЭтотОбъект), ТекстВопроса, СписокВариантовОтветовНаВопрос, 0,,НСтр("ru = 'Выбор банка из классификатора'"));
            КонецЕсли;	
	КонецЕсли;	
		
КонецПроцедуры

&НаКлиенте
Процедура РеквизитБанкаПриИзмененииЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    Ответ = РезультатВопроса;
    
    Если Ответ = "ОтменитьВвод" Тогда
        БИКБанка = "";
    ИначеЕсли Ответ = "ПродолжитьВвод" Тогда
        РучноеИзменениеРеквизитовБанка = Истина;
        БИКБанка = БИКБанка;
    ИначеЕсли Ответ = "ВыбратьИзСписка" Тогда
        СтруктураПараметров = Новый Структура;
        СтруктураПараметров.Вставить("Реквизит", "БИКБанка");
        ОткрытьФорму("Справочник.КлассификаторБанков.Форма.ФормаВыбора", СтруктураПараметров, ЭтаФорма);
    КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура РеквизитБанкаПриВыборе(ИмяЭлемента, Форма)
	Если ИмяЭлемента = "БИКБанка" Тогда
			СтруктураПараметров = Новый Структура;
			СтруктураПараметров.Вставить("Реквизит", ИмяЭлемента);
       		ОткрытьФорму("Справочник.КлассификаторБанков.Форма.ФормаВыбора", СтруктураПараметров, Форма);
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура РеквизитБанкаОткрытие(ИмяЭлемента)
	
	СтруктураПараметров = Новый Структура;
    СтруктураПараметров.Вставить("Реквизит", ИмяЭлемента);
    ЗначенияПараметров = Новый Структура;
	
	Если ИмяЭлемента = "БИКБанка" Тогда
		СтруктураПараметров.Вставить("РучноеИзменение", Ложь);
		
		СтруктураПараметров.Вставить("Банк", Банк);
	КонецЕсли;
	
	СтруктураПараметров.Вставить("ЗначенияПолей", ЗначенияПараметров);
	ОткрытьФорму("Справочник.БанковскиеСчетаОрганизаций.Форма.РеквизитыБанка",СтруктураПараметров, ЭтаФорма);
			    	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервере
Функция ЗаполнитьРеквизитыБанкаПоБИК(БИК, ТипБанка, ПеренестиЗначенияРеквизитов)
	
	НашлиПоБИК	 = Ложь;
	ЗаписьОБанке = "";
	
	Если ТипБанка = "Банк" Тогда
		БИКБанка		  = "";
		КоррСчетБанка	  = "";
		НаименованиеБанка = "";
		ГородБанка		  = "";
		РаботаСБанками.ПолучитьДанныеКлассификатора(БИК,,ЗаписьОБанке);
		Если НЕ ПустаяСтрока(ЗаписьОБанке) Тогда
			БИКБанка		  = ЗаписьОБанке.Код;
			КоррСчетБанка	  = ЗаписьОБанке.КоррСчет;
			НаименованиеБанка = ЗаписьОБанке.Наименование;
			ГородБанка		  = ЗаписьОБанке.Город;
			НашлиПоБИК		  = Истина;
			Банк				 = ЗаписьОБанке;
		КонецЕсли;		
	КонецЕсли;
	Возврат НашлиПоБИК;
КонецФункции

&НаСервере
Функция ЗаполнитьРеквизитыБанкаПоБанку(Банк, ТипБанка, ПеренестиЗначенияРеквизитов)
	Если ТипЗнч(Банк) = Тип("СправочникСсылка.КлассификаторБанков") Тогда
		Если ТипБанка = "Банк" Тогда
			РеквизитыБанка = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Банк, "Код, КоррСчет, Наименование, Город");
			БИКБанка			= РеквизитыБанка.Код;
			КоррСчетБанка		= РеквизитыБанка.КоррСчет;
			НаименованиеБанка 	= РеквизитыБанка.Наименование;
			ГородБанка			= РеквизитыБанка.Город;
		КонецЕсли;
	КонецЕсли;
КонецФункции

#КонецОбласти

#КонецОбласти
