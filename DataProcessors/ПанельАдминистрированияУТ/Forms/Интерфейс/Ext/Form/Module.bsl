﻿
#Область ОписаниеПеременных

&НаКлиенте
Перем ОбновитьИнтерфейс;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ОбщегоНазначенияУТ.ПереключениеИнтерфейсаПриСозданииНаСервере(ЭтаФорма);
	Если НЕ ПолучитьФункциональнуюОпцию("УправлениеТорговлей") Тогда
		Элементы.ГруппаФункциональностьУТ.Видимость = Ложь;
	Иначе
		Элементы.ГруппаФункциональностьУТ.Видимость = Истина;
		Если ПолучитьФункциональнуюОпцию("БазоваяВерсия") Тогда
			ФункциональностьПрограммы = "БазоваяВерсия";
		Иначе
			ФункциональностьПрограммы = "ПолнаяФункциональность";
		КонецЕсли;
	КонецЕсли; 

КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	ОбновитьИнтерфейсПрограммы();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбновитьИнтерфейсПрограммы()
	
	Если ОбновитьИнтерфейс = Истина Тогда
		ОбновитьИнтерфейс = Ложь;
		ОбщегоНазначенияКлиент.ОбновитьИнтерфейсПрограммы();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Перезапустить(Команда)
	
	УстановитьИнтерфейсНаСервере(ВариантИнтерфейса);
	
	ЗавершитьРаботуСистемы(Ложь, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ВариантИнтерфейсаПриИзменении(Элемент)

	Если ВариантИнтерфейсаДоИзменения <> ВариантИнтерфейса Тогда
		Элементы.ГруппаПерезапускКнопка.Видимость = Истина;
	Иначе
		Элементы.ГруппаПерезапускКнопка.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура УстановитьИнтерфейсНаСервере(ВариантИнтерфейса)
	
	ОбщегоНазначенияУТ.УстановитьРежимКомандногоИнтерфейса(ВариантИнтерфейса);
	
КонецПроцедуры

&НаКлиенте
Процедура ФункциональностьПрограммыПриИзменении(Элемент)
	
	Если ФункциональностьПрограммы = "БазоваяВерсия" Тогда
		НаборКонстант.БазоваяВерсия = Истина;
	Иначе
		НаборКонстант.БазоваяВерсия = Ложь;
	КонецЕсли;
	
	Подключаемый_ПриИзмененииРеквизита(Элементы.БазоваяВерсия);
	
	Если ФункциональностьПрограммы = "БазоваяВерсия" Тогда
		Закрыть();
		ОткрытьФорму("ОбщаяФорма.ФормаНастройкиОрганизации", Новый Структура);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииРеквизита(Элемент, ОбновлятьИнтерфейс = Истина)
	
	КонстантаИмя = ПриИзмененииРеквизитаСервер(Элемент.Имя);
	
	Если ОбновлятьИнтерфейс Тогда
		ОбновитьИнтерфейс = Истина;
		ПодключитьОбработчикОжидания("ОбновитьИнтерфейсПрограммы", 2, Истина);
	КонецЕсли;
	
	Если КонстантаИмя <> "" Тогда
		Оповестить("Запись_НаборКонстант", Новый Структура, КонстантаИмя);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПриИзмененииРеквизитаСервер(ИмяЭлемента)
	
	РеквизитПутьКДанным = Элементы[ИмяЭлемента].ПутьКДанным;
	
	КонстантаИмя = СохранитьЗначениеРеквизита(РеквизитПутьКДанным);
	
	ОбновитьПовторноИспользуемыеЗначения();
	
	Возврат КонстантаИмя;
	
КонецФункции

&НаСервере
Функция СохранитьЗначениеРеквизита(РеквизитПутьКДанным)
	
	// Определение имени константы.
	КонстантаИмя = "";
	Если СтрНачинаетсяС(НРег(РеквизитПутьКДанным), НРег("НаборКонстант.")) Тогда
		// Если путь к данным реквизита указан через "НаборКонстант".
		ЧастиИмени = СтрРазделить(РеквизитПутьКДанным, ".");
		КонстантаИмя = ЧастиИмени[1];
	Иначе
		// Определение имени и запись значения реквизита в соответствующей константе из "НаборКонстант".
		// Используется для тех реквизитов формы, которые связаны с константами напрямую (в отношении один-к-одному).
	КонецЕсли;
	
	// Сохранения значения константы.
	Если КонстантаИмя <> "" Тогда
		КонстантаМенеджер = Константы[КонстантаИмя];
		КонстантаЗначение = НаборКонстант[КонстантаИмя];
		
		Если КонстантаМенеджер.Получить() <> КонстантаЗначение Тогда
			КонстантаМенеджер.Установить(КонстантаЗначение);
		КонецЕсли;
	КонецЕсли;
	
	Возврат КонстантаИмя;
	
КонецФункции

#КонецОбласти
