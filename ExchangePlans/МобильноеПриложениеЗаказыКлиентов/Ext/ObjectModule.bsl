﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Наименование) Тогда
		Если ЭтотУзел Тогда
			Наименование = НСтр("ru = 'Центральный'");
		Иначе
			ТекстНаименование = НСтр("ru = '%Пользователь% (""1С:Заказы"")'");
			ТекстНаименование = СтрЗаменить(ТекстНаименование, "%Пользователь%", СокрЛП(Пользователь));
			Наименование = ТекстНаименование;
		КонецЕсли;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Код) Тогда
		Если ЭтотУзел Тогда
			Код = "001";
		Иначе
			НовыйКод = СокрЛП(Пользователь.УникальныйИдентификатор());
			ПроверитьНовыйКод(НовыйКод, ЭтотОбъект.Ссылка, Отказ);
			Если Отказ Тогда
				Сообщение = НСтр("ru = 'Для пользователя ""%Пользователь%"" уже существует настройка,
				|которая еще не была задействована для синхронизации данных с мобильным приложением.
				|Используйте ее для настройки обмена данными.'");
				Сообщение = СтрЗаменить(Сообщение, "%Пользователь%", Пользователь);
				Поле = "Пользователь";
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Сообщение, ЭтотОбъект, Поле,, Отказ);
				Возврат;
			Иначе
				Код = НовыйКод;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Если НЕ ЭтотУзел Тогда
		
		ПрефиксИспользуется = МобильноеПриложениеЗаказыКлиентовПереопределяемый.ПроверитьПрефиксДляДанныхМобильногоУстройства(
		Ссылка, ПрефиксДляДанныхМобильногоУстройства);
		
		Если ПрефиксИспользуется Тогда
			Сообщение = НСтр("ru = 'Префикс ""%Префикс%"" уже используется !'");
			Сообщение = СтрЗаменить(Сообщение, "%Префикс%", ПрефиксДляДанныхМобильногоУстройства);
			Поле = "ПрефиксДляДанныхМобильногоУстройства";
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Сообщение, ЭтотОбъект, Поле,, Отказ);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	ДобавитьНепроверяемыеРеквизитыВМассив(МассивНепроверяемыхРеквизитов);
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Код = "";
	Наименование = "";
	ПрефиксДляДанныхМобильногоУстройства = "";
	ИдентификаторПодписчикаДоставляемыхУведомлений = Неопределено;
КонецПроцедуры

Процедура ПередУдалением(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ПланыОбмена.УдалитьРегистрациюИзменений(Ссылка);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЭтотУзел И ЗначениеЗаполнено(Ссылка) И НЕ ПометкаУдаления
		И Код = СокрЛП(Пользователь.УникальныйИдентификатор()) Тогда
		ПланыОбмена.ЗарегистрироватьИзменения(Ссылка, Метаданные.Справочники.Партнеры);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ДобавитьНепроверяемыеРеквизитыВМассив(МассивНепроверяемыхРеквизитов)
	
	Если Ссылка = ПланыОбмена.МобильноеПриложениеЗаказыКлиентов.ЭтотУзел() Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Пользователь");
		МассивНепроверяемыхРеквизитов.Добавить("ПрефиксДляДанныхМобильногоУстройства");
	КонецЕсли;
	
	МассивНепроверяемыхРеквизитов.Добавить("Код");
	МассивНепроверяемыхРеквизитов.Добавить("Наименование");
	
КонецПроцедуры

Процедура ПроверитьНовыйКод(НовыйКод, СсылкаНаОбъект, Отказ)
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	|	МобильноеПриложениеЗаказыКлиентов.Ссылка
	|ИЗ
	|	ПланОбмена.МобильноеПриложениеЗаказыКлиентов КАК МобильноеПриложениеЗаказыКлиентов
	|ГДЕ
	|	НЕ МобильноеПриложениеЗаказыКлиентов.Ссылка = &СсылкаНаОбъект
	|	И МобильноеПриложениеЗаказыКлиентов.Код = &Код");
	
	Запрос.УстановитьПараметр("СсылкаНаОбъект", СсылкаНаОбъект);
	Запрос.УстановитьПараметр("Код", НовыйКод);
	
	Результат = Запрос.Выполнить();
	
	Если НЕ Результат.Пустой() Тогда
		Отказ = Истина;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#КонецЕсли
