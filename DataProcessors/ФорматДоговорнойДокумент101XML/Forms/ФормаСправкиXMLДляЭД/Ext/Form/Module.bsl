﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ВыбранныйФайл = Параметры.ВыбранныйФайл;
	ИдентификаторОсновногоФайла = Параметры.ИдентификаторОсновногоФайла;
	
	Если ЗначениеЗаполнено(ВыбранныйФайл) Тогда
		ПроверкаФайлаXML(ВыбранныйФайл);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДекорацияГиперссылкаНажатие(Элемент)
	
	Закрыть("Редактирование");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда) 
	
	Если ЗначениеЗаполнено(ВыбранныйФайл) Тогда	
		ОбновитьДанныеФайла();
	КонецЕсли;
	
	Закрыть("Отправка");
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьНажатие(Команда)
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПроверкаФайлаXML(ВыбранныйФайл)
	
	ИнформацияПоФайлу = РаботаСФайлами.ДанныеФайла(ВыбранныйФайл);
	
	Если ИнформацияПоФайлу = Неопределено Тогда
		
		ТекстОшибки = НСтр("ru = 'Не удалось получить информацию по выбранному файлу. Возможно нет прав на работу с файлом.'");
		Элементы.ДекорацияПредупреждение.Заголовок = ТекстОшибки;
		Элементы.ОК.Видимость = Ложь;
		Элементы.ГруппаГиперссылка.Видимость = Ложь;
		Элементы.Закрыть.Видимость = Истина;
		
	ИначеЕсли ИнформацияПоФайлу.ПометкаУдаления Тогда
		
		Элементы.ГруппаГиперссылка.ТолькоПросмотр = Истина;
		ТекстОшибки = НСтр("ru = 'Файл помечен на удаление. Отправка невозможна.'");
		Элементы.ДекорацияПредупреждение.Заголовок = ТекстОшибки;
		Элементы.ОК.Видимость = Ложь;
		Элементы.ГруппаГиперссылка.Видимость = Ложь;
		Элементы.Закрыть.Видимость = Истина;
		
	ИначеЕсли ИнформацияПоФайлу.ФайлРедактируется Тогда
		
		Элементы.ГруппаГиперссылка.ТолькоПросмотр = Истина;
		ТекстОшибки = НСтр("ru = 'Файл редактируется. Отправка невозможна.'");
		Элементы.ДекорацияПредупреждение.Заголовок = ТекстОшибки;
		Элементы.ОК.Видимость = Ложь;
		Элементы.ГруппаГиперссылка.Видимость = Ложь;
		Элементы.Закрыть.Видимость = Истина;
		
	Иначе
		
		Если ИнформацияПоФайлу.ПодписанЭП Тогда
			Элементы.ГруппаГиперссылка.ТолькоПросмотр = Истина;
			ТекстПодсказки = НСтр("ru = 'Файл подписан электронной подписью. Редактирование невозможно.'");
			Элементы.ДекорацияГиперссылка.Заголовок = ТекстПодсказки;
			Элементы.ДекорацияГиперссылка.Доступность = Ложь;
			Элементы.ДекорацияГиперссылка.Гиперссылка = Ложь;
		КонецЕсли;
		
		ДанныеФайла = РаботаСФайлами.ДвоичныеДанныеФайла(ВыбранныйФайл);
		
		ТаблицаФрагментов = Обработки.ФорматДоговорнойДокумент101XML.ЗагрузкаXMLВТаблицуФрагментов(ДанныеФайла);
		Если ТаблицаФрагментов = Неопределено
			Или ТаблицаФрагментов.Количество() = 0 Тогда
			ТекстОшибки = НСтр("ru = 'Нет данных по фрагментам. Неверный формат файла, либо файл пустой.'");
			Элементы.ДекорацияПредупреждение.Заголовок = ТекстОшибки;
			Элементы.ОК.Видимость = Ложь;
			Элементы.ГруппаГиперссылка.Видимость = Ложь;
			Элементы.Закрыть.Видимость = Истина;
		Иначе
			Ошибки = Обработки.ФорматДоговорнойДокумент101XML.ПроверитьЗаполненностьТиповыхФрагментов(ТаблицаФрагментов);
			Если Ошибки <> Неопределено Тогда
				Элементы.ОК.Видимость = Ложь;
				Элементы.Закрыть.Видимость = Истина;
				ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'При формировании фрагментов произошли следующие ошибки:'"));
				ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки);
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьДанныеФайла()
	
	ДвоичныеДанныеXML = РаботаСФайлами.ДвоичныеДанныеФайла(ВыбранныйФайл);
	Адрес = ПоместитьВоВременноеХранилище(ДвоичныеДанныеXML);
			
	ИнформацияОФайле = Новый Структура();
	ИнформацияОФайле.Вставить("АдресФайлаВоВременномХранилище", Адрес);
	ИнформацияОФайле.Вставить("АдресВременногоХранилищаТекста", Адрес);
	ИнформацияОФайле.Вставить("ИмяБезРасширения", ИдентификаторОсновногоФайла);
	
	РаботаСФайлами.ОбновитьФайл(ВыбранныйФайл, ИнформацияОФайле);
	
КонецПроцедуры

#КонецОбласти
