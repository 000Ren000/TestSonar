﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("ПараметрКоманды") Тогда
		Если ТипЗнч(Параметры.ПараметрКоманды) = Тип("СправочникСсылка.ДоговорыКонтрагентов") Тогда
			ВходящиеДокументы.Добавить(ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Параметры.ПараметрКоманды, "ГрафикИсполненияДоговора"));
		Иначе
			ВходящиеДокументы.ЗагрузитьЗначения(Параметры.ПараметрКоманды);
		КонецЕсли;
	ИначеЕсли ЗначениеЗаполнено(Параметры.ВходящиеДокументы) Тогда
		ВходящиеДокументы = Параметры.ВходящиеДокументы;
	Иначе
		Отказ = Истина;
	КонецЕсли;
	
	Если НЕ Отказ Тогда
		СформироватьОтчет();
	Иначе
		ВызватьИсключение НСтр("ru='Отчет не предназначен для интерактивного открытия.'");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыОтчета

// Параметры:
// 	Элемент - ПолеФормы
// 	Область - ОбластьЯчеекТабличногоДокумента - Содержит:
// 		* Расшифровка - Структура:
// 			** Заказ - ДокументСсылка
// 			** Действие - Строка
// 	СтандартнаяОбработка - Булево
//
&НаКлиенте
Процедура ТаблицаОтчетаВыбор(Элемент, Область, СтандартнаяОбработка)
	
	Если НЕ ЗначениеЗаполнено(Область.Расшифровка) Тогда
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	
	СтруктураПараметров = Область.Расшифровка;
	
	Если СтруктураПараметров.Действие = "ОткрытьСостояниеОбеспечения" Тогда
		
		ПараметрыФормы = ОбеспечениеВДокументахКлиент.ПараметрыФормыСостояниеОбеспеченияЗаказов("ЗАКАЗ");
		ПараметрыФормы.Заказ = СтруктураПараметров.Заказ;
		ПараметрыФормы.ТолькоПросмотр = Истина;
		ОткрытьФорму("Обработка.СостояниеОбеспеченияЗаказов.Форма",
			ПараметрыФормы,
			ЭтаФорма,
			УникальныйИдентификатор);
		
	ИначеЕсли СтруктураПараметров.Действие = "ОткрытьЗначение" Тогда
		ПоказатьЗначение(,СтруктураПараметров.Заказ);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Сформировать(Команда)
	ОчиститьСообщения();
	СформироватьОтчет();
КонецПроцедуры 

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура СформироватьОтчет()
	
	ТаблицаОтчета.Очистить();
	Отчеты.СостояниеВыполненияДокументов.СформироватьОтчетСостояниеВыполненияДокументов(ВходящиеДокументы, ТаблицаОтчета);
	
КонецПроцедуры


#КонецОбласти
