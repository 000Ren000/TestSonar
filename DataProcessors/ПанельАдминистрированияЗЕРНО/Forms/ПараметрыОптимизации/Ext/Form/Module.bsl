﻿#Область ОписаниеПеременных

&НаКлиенте
Перем ОбновитьИнтерфейс;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыОптимизации = ИнтеграцияЗЕРНО.ПараметрыОптимизации();
	
	ВерсияAPI                                          = ПараметрыОптимизации.ВерсияAPI;
	КоличествоЗапросовВМинуту                          = ПараметрыОптимизации.КоличествоЗапросовВМинуту;
	ИнтервалМеждуОтправкойЗапросаИПолучениемРезультата = ПараметрыОптимизации.ИнтервалМеждуОтправкойЗапросаИПолучениемРезультата;
	ИнтервалМеждуПолучениемРезультатов                 = ПараметрыОптимизации.ИнтервалМеждуПолучениемРезультатов;
	ТаймаутHTTPЗапросов                                = ПараметрыОптимизации.ТаймаутHTTPЗапросов;
	КоличествоЭлементовСтраницыОтвета                  = ПараметрыОптимизации.КоличествоЭлементовСтраницыОтвета;
	КоличествоЭлементовСтраницыОтветаСправочника       = ПараметрыОптимизации.КоличествоЭлементовСтраницыОтветаСправочника;
	ИспользоватьПодтверждениеПолученияСообщения        = ПараметрыОптимизации.ИспользоватьПодтверждениеПолученияСообщения;
	ДатаОграниченияГлубиныДереваПартий                 = ПараметрыОптимизации.ДатаОграниченияГлубиныДереваПартий;
	
	Элементы.ВерсияAPI.СписокВыбора.Добавить(ИнтеграцияЗЕРНО.ВерсияAPI());
	
	ДополнитьСписокВыбора("КоличествоЗапросовВМинуту",                          Ложь,   НСтр("ru = 'в минуту'"));
	ДополнитьСписокВыбора("ИнтервалМеждуОтправкойЗапросаИПолучениемРезультата", Истина, НСтр("ru = 'секунда'"), Истина);
	ДополнитьСписокВыбора("ИнтервалМеждуПолучениемРезультатов",                 Истина, НСтр("ru = 'секунда'"), Истина);
	ДополнитьСписокВыбора("ТаймаутHTTPЗапросов",                                Истина, НСтр("ru = 'секунда'"), Истина);
	ДополнитьСписокВыбора("КоличествоЭлементовСтраницыОтвета",                  Ложь,   НСтр("ru = 'элемент'"), Истина);
	ДополнитьСписокВыбора("КоличествоЭлементовСтраницыОтветаСправочника",       Ложь,   НСтр("ru = 'элемент'"), Истина);
	ДополнитьСписокВыбора("ВерсияAPI");
	
	ЗаполнитьПредставленияПодсказокЭлементов();
	
	// Обновление состояния элементов
	УстановитьДоступность();
	
	ОбщегоНазначенияСобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	ОбновитьИнтерфейсПрограммы();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВерсияAPIПриИзменении(Элемент)
	ПриИзмененииНастройкиКлиент(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура КоличествоЗапросовВМинутуПриИзменении(Элемент)
	ПриИзмененииНастройкиКлиент(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИнтервалМеждуОтправкойЗапросаИПолучениемРезультатаПриИзменении(Элемент)
	ПриИзмененииНастройкиКлиент(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИнтервалМеждуПолучениемРезультатовПриИзменении(Элемент)
	ПриИзмененииНастройкиКлиент(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ВерсияAPIОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура КоличествоЗапросовВМинутуОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ИнтервалМеждуОтправкойЗапросаИПолучениемРезультатаОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ИнтервалМеждуПолучениемРезультатовОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ТаймаутHTTPЗапросовПриИзменении(Элемент)
	ПриИзмененииНастройкиКлиент(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ТаймаутHTTPЗапросовОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура КоличествоЭлементовСтраницыОтветаПриИзменении(Элемент)
	ПриИзмененииНастройкиКлиент(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура КоличествоЭлементовСтраницыОтветаОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура КоличествоЭлементовСтраницыОтветаСправочникаПриИзменении(Элемент)
	ПриИзмененииНастройкиКлиент(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура КоличествоЭлементовСтраницыОтветаСправочникаОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьПодтверждениеПолученияСообщенияПриИзменении(Элемент)
	ПриИзмененииНастройкиКлиент(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ДатаОграниченияГлубиныДереваПартийПриИзменении(Элемент)
	ПриИзмененииНастройкиКлиент(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ДатаОграниченияГлубиныДереваПартийОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ТекстПодсказкиПоЗначению(Значение, СклоняемоеЗначение, Знач Падеж = "Именительный")
		
	Результат = ПолучитьСклоненияСтрокиПоЧислу(
		СклоняемоеЗначение,
		Значение,,
		"ЧС=Количественное;Л=ru_RU",
		СтрШаблон("ПД=%1", Падеж));
	
	Если Результат.Количество() Тогда
		Возврат СокрЛП(СтрЗаменить(Результат[0], Значение, ""));
	Иначе
		Возврат СклоняемоеЗначение;
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура ПриИзмененииНастройкиКлиент(Элемент)
	
	Результат = ПриИзмененииНастройкиСервер(Элемент.Имя);
	
	Если Результат <> "" Тогда
		Оповестить("Запись_НаборКонстант", Новый Структура, Результат);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПриИзмененииНастройкиСервер(ИмяЭлемента)
	
	Результат = Новый Структура;
	ЗаполнитьПредставленияПодсказокЭлементов();
	
	НачатьТранзакцию();
	Попытка
		
		ПараметрыОптимизации = ИнтеграцияЗЕРНО.ПараметрыОптимизации();
		ПараметрыОптимизации.ИнтервалМеждуОтправкойЗапросаИПолучениемРезультата = ИнтервалМеждуОтправкойЗапросаИПолучениемРезультата;
		ПараметрыОптимизации.ИнтервалМеждуПолучениемРезультатов                 = ИнтервалМеждуПолучениемРезультатов;
		ПараметрыОптимизации.КоличествоЗапросовВМинуту                          = КоличествоЗапросовВМинуту;
		ПараметрыОптимизации.КоличествоЭлементовСтраницыОтвета                  = КоличествоЭлементовСтраницыОтвета;
		ПараметрыОптимизации.КоличествоЭлементовСтраницыОтветаСправочника       = КоличествоЭлементовСтраницыОтветаСправочника;
		ПараметрыОптимизации.ИспользоватьПодтверждениеПолученияСообщения        = ИспользоватьПодтверждениеПолученияСообщения;
		ПараметрыОптимизации.ДатаОграниченияГлубиныДереваПартий                 = ДатаОграниченияГлубиныДереваПартий;
		ПараметрыОптимизации.ТаймаутHTTPЗапросов                                = ТаймаутHTTPЗапросов;
		
		ИнтеграцияЗЕРНОСлужебный.ЗаписатьПараметрыОптимизации(ПараметрыОптимизации);
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		ИнфрмацияОшибки = ИнформацияОбОшибке();
		ЗаписьЖурналаРегистрации(
			НСтр("ru = 'Выполнение операции'", ОбщегоНазначения.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка,,,
			ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнфрмацияОшибки));
		
		ВызватьИсключение;
		
	КонецПопытки;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура УстановитьДоступность(РеквизитПутьКДанным = "")
	
	ПраваНаРедактирование = ПраваНаРедактированиеЭлементовФормы();
	
	Для Каждого ЭлементФормы Из Элементы Цикл
		
		Если ТипЗнч(ЭлементФормы) = Тип("ПолеФормы") Тогда
			
			МассивПодстрок = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ЭлементФормы.ПутьКДанным, ".");
			ИмяРеквизитаФормы = МассивПодстрок[МассивПодстрок.ВГраница()];
			ПравоТолькоПросмотр = Не ПраваНаРедактирование.Получить(ИмяРеквизитаФормы);
			ЭлементФормы.ТолькоПросмотр = ПравоТолькоПросмотр; 
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПредставленияПодсказокЭлементов()
	
	Источник = Новый Структура();
	Источник.Вставить("ИнтервалМеждуОтправкойЗапросаИПолучениемРезультата", НСтр("ru = 'секунда'"));
	Источник.Вставить("ИнтервалМеждуПолучениемРезультатов",                 НСтр("ru = 'секунда'"));
	Источник.Вставить("ТаймаутHTTPЗапросов",                                НСтр("ru = 'секунда'"));
	Источник.Вставить("КоличествоЭлементовСтраницыОтвета",                  НСтр("ru = 'элемент'"));
	Источник.Вставить("КоличествоЭлементовСтраницыОтветаСправочника",       НСтр("ru = 'элемент'"));
	
	Для Каждого КлючИЗначение Из Источник Цикл
		ТекстПодсказки = ТекстПодсказкиПоЗначению(ЭтотОбъект[КлючИЗначение.Ключ], КлючИЗначение.Значение);
		Элементы[КлючИЗначение.Ключ].РасширеннаяПодсказка.Заголовок = ТекстПодсказки;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ПраваНаРедактированиеЭлементовФормы()
	
	Соответствие = Новый Соответствие;
	
	НастройкиОбменаЗЕРНО = ИнтеграцияЗЕРНО.ПараметрыОптимизации();
	ПравоРедактирования = ПравоДоступа("Редактирование", Метаданные.Константы.НастройкиОбменаЗЕРНО);
	Для Каждого КлючЗначение Из НастройкиОбменаЗЕРНО Цикл
		Соответствие.Вставить(КлючЗначение.Ключ, ПравоРедактирования);
	КонецЦикла;
	
	Возврат Соответствие;
	
КонецФункции

&НаКлиенте
Процедура ОбновитьИнтерфейсПрограммы()
	
	Если ОбновитьИнтерфейс = Истина Тогда
		ОбновитьИнтерфейс = Ложь;
		ОбщегоНазначенияКлиент.ОбновитьИнтерфейсПрограммы();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ДополнитьСписокВыбора(ИмяРеквизита, СформироватьПредставлениеДаты = Ложь, ПроизвольноеПредставление = Неопределено, СклонятьПредставление = Ложь)

	СписокВыбора = Элементы[ИмяРеквизита].СписокВыбора;
	Значение     = ЭтотОбъект[ИмяРеквизита];
	
	Если СписокВыбора.НайтиПоЗначению(Значение) <> Неопределено Тогда
		Возврат;
	КонецЕсли;

	ПредставлениеЗначения = Строка(Значение);
	Если СформироватьПредставлениеДаты И Значение > 0 Тогда
		ПредставлениеЗначения = ПредставлениеВремени(Значение);
	КонецЕсли;
	
	Если ПроизвольноеПредставление <> Неопределено Тогда
		Если СклонятьПредставление Тогда
			ПредставлениеЗначения = СтрШаблон(
				"%1 %2",
				Значение,
				ТекстПодсказкиПоЗначению(Значение, ПроизвольноеПредставление));
		Иначе
			ПредставлениеЗначения = СтрШаблон("%1 %2", Значение, ПроизвольноеПредставление);
		КонецЕсли;
	КонецЕсли;
	
	СписокВыбора.Добавить(Значение, ПредставлениеЗначения);
	СписокВыбора.СортироватьПоЗначению();
	
КонецПроцедуры

&НаСервере
Функция ПредставлениеВремени(ОбщееКоличествоСекунд)
	
	ОбщаяДата = Дата(1, 1, 1) + ОбщееКоличествоСекунд;
	
	Дней   = ДеньГода(ОбщаяДата) - 1;
	Часов  = Час(ОбщаяДата);
	Минут  = Минута(ОбщаяДата);
	Секунд = Секунда(ОбщаяДата);
	
	Строки = Новый Массив;
	
	Если Дней > 0 Тогда
		Строки.Добавить(СтрШаблон(НСтр("ru = '%1 дн.'"), Дней));
	КонецЕсли;
	Если Часов > 0 Тогда
		Строки.Добавить(СтрШаблон(НСтр("ru = '%1 ч.'"), Часов));
	КонецЕсли;
	Если Минут > 0 Тогда
		Строки.Добавить(СтрШаблон(НСтр("ru = '%1 мин.'"), Минут));
	КонецЕсли;
	Если Секунд > 0 Или Строки.Количество() = 0 Тогда
		Строки.Добавить(СтрШаблон(НСтр("ru = '%1 сек.'"), Секунд));
	КонецЕсли;
	
	Возврат СтрСоединить(Строки, " ");
	
КонецФункции

#КонецОбласти