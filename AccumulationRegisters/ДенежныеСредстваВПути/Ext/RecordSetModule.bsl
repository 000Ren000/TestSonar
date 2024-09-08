﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ПроведениеДокументов.КонтролироватьИзменения(ДополнительныеСвойства) Тогда
		Возврат;
	КонецЕсли;
	
	// Текущее состояние набора помещается во временную таблицу,
	// чтобы при записи получить изменение нового набора относительно текущего.
	
	ТекстыЗапросовДляПолученияТаблицыИзменений = 
		ЗакрытиеМесяцаСервер.ТекстыЗапросовДляПолученияТаблицыИзмененийРегистра(Метаданные(), Отбор);
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = ДополнительныеСвойства.МенеджерВременныхТаблиц;
	Запрос.Текст = ТекстыЗапросовДляПолученияТаблицыИзменений.ТекстВыборкиНачальныхДанных;
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	
	Запрос.Выполнить();
	
	ДополнительныеСвойства.Вставить("ТекстВыборкиТаблицыИзменений", ТекстыЗапросовДляПолученияТаблицыИзменений.ТекстВыборкиТаблицыИзменений);
	
	СформироватьТаблицуОбъектовОплаты();
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Или Не ПроведениеДокументов.КонтролироватьИзменения(ДополнительныеСвойства) Тогда
		Возврат;
	КонецЕсли;
	
	// Рассчитывается изменение нового набора относительно текущего с учетом накопленных изменений
	// и помещается во временную таблицу для последующей записи в регистрах заданий.
	Запрос = Новый Запрос;
	Запрос.Текст = ДополнительныеСвойства.ТекстВыборкиТаблицыИзменений;
	Запрос.МенеджерВременныхТаблиц = ДополнительныеСвойства.МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);	
	
	Запрос.Выполнить();
	
	РегистрыСведений.ГрафикПлатежей.РассчитатьГрафикПлатежейПоДенежнымСредствамВПути(ДополнительныеСвойства.ТаблицаОбъектовОплаты);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Формирует таблицу отправителей и получателей, которые были раньше в движениях и которые будут записаны.
//
Процедура СформироватьТаблицуОбъектовОплаты()
	
	ВидыПереводовМеждуМестамиХранения = Новый Массив;
	ВидыПереводовМеждуМестамиХранения.Добавить(Перечисления.ВидыПереводовДенежныхСредств.ИнкассацияВБанк);
	ВидыПереводовМеждуМестамиХранения.Добавить(Перечисления.ВидыПереводовДенежныхСредств.ИнкассацияИзБанка);
	ВидыПереводовМеждуМестамиХранения.Добавить(Перечисления.ВидыПереводовДенежныхСредств.ПеремещениеВДругуюКассу);
	ВидыПереводовМеждуМестамиХранения.Добавить(Перечисления.ВидыПереводовДенежныхСредств.ПеречислениеНаДругойСчет);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	Запрос.Текст = "
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДенежныеСредстваВПути.Получатель КАК БанковскийСчетКасса,
	|	
	|	ВЫБОР КОГДА ВидПереводаДенежныхСредств В (
	|		ЗНАЧЕНИЕ(Перечисление.ВидыПереводовДенежныхСредств.ИнкассацияВБанк),
	|		ЗНАЧЕНИЕ(Перечисление.ВидыПереводовДенежныхСредств.ИнкассацияИзБанка),
	|		ЗНАЧЕНИЕ(Перечисление.ВидыПереводовДенежныхСредств.ПеречислениеНаДругойСчет),
	|		ЗНАЧЕНИЕ(Перечисление.ВидыПереводовДенежныхСредств.ПеремещениеВДругуюКассу))
	|	ТОГДА
	|		ДенежныеСредстваВПути.Отправитель
	|	КОГДА ВидПереводаДенежныхСредств В (
	|		ЗНАЧЕНИЕ(Перечисление.ВидыПереводовДенежныхСредств.ПриобретениеВалюты),
	|		ЗНАЧЕНИЕ(Перечисление.ВидыПереводовДенежныхСредств.РеализацияВалюты))
	|	ТОГДА
	|		ДенежныеСредстваВПути.Контрагент
	|	КОНЕЦ КАК ОбъектОплаты
	|ИЗ
	|	РегистрНакопления.ДенежныеСредстваВПути КАК ДенежныеСредстваВПути
	|ГДЕ
	|	ДенежныеСредстваВПути.Регистратор = &Регистратор
	|	И ВЫБОР КОГДА ВидПереводаДенежныхСредств В (
	|		ЗНАЧЕНИЕ(Перечисление.ВидыПереводовДенежныхСредств.ИнкассацияВБанк),
	|		ЗНАЧЕНИЕ(Перечисление.ВидыПереводовДенежныхСредств.ИнкассацияИзБанка),
	|		ЗНАЧЕНИЕ(Перечисление.ВидыПереводовДенежныхСредств.ПеречислениеНаДругойСчет),
	|		ЗНАЧЕНИЕ(Перечисление.ВидыПереводовДенежныхСредств.ПеремещениеВДругуюКассу))
	|	ТОГДА
	|		ДенежныеСредстваВПути.Отправитель
	|	КОГДА ВидПереводаДенежныхСредств В (
	|		ЗНАЧЕНИЕ(Перечисление.ВидыПереводовДенежныхСредств.ПриобретениеВалюты),
	|		ЗНАЧЕНИЕ(Перечисление.ВидыПереводовДенежныхСредств.РеализацияВалюты))
	|	ТОГДА
	|		ДенежныеСредстваВПути.Контрагент
	|	КОНЕЦ <> НЕОПРЕДЕЛЕНО
	|	И ДенежныеСредстваВПути.ВидПереводаДенежныхСредств <> ЗНАЧЕНИЕ(Перечисление.ВидыПереводовДенежныхСредств.ПоступлениеОтБанкаПоЭквайрингу)
	|";
	
	ТаблицаОбъектовОплаты = Запрос.Выполнить().Выгрузить();
	
	ТаблицаНовыхОбъектовОплаты = ОбъектыОплатыПоНаборуЗаписей();
	
	Для каждого Запись Из ТаблицаНовыхОбъектовОплаты Цикл
		
		Если Запись.ВидПереводаДенежныхСредств = Перечисления.ВидыПереводовДенежныхСредств.ПоступлениеОтБанкаПоЭквайрингу Тогда
			Продолжить;
		КонецЕсли;
		
		СтруктураПоиска = Новый Структура;;
		СтруктураПоиска.Вставить("БанковскийСчетКасса", Запись.Получатель);
		Если ВидыПереводовМеждуМестамиХранения.Найти(Запись.ВидПереводаДенежныхСредств) <> Неопределено Тогда
			Если ЗначениеЗаполнено(Запись.Отправитель) Тогда
				СтруктураПоиска.Вставить("ОбъектОплаты", Запись.Отправитель);
			Иначе
				Продолжить;
			КонецЕсли;
		Иначе
			СтруктураПоиска.Вставить("ОбъектОплаты", Запись.Контрагент);
		КонецЕсли;
		
		Если Не ТаблицаОбъектовОплаты.НайтиСтроки(СтруктураПоиска).Количество() Тогда
			НоваяСтрока = ТаблицаОбъектовОплаты.Добавить();
			НоваяСтрока.ОбъектОплаты = СтруктураПоиска.ОбъектОплаты;
			НоваяСтрока.БанковскийСчетКасса = СтруктураПоиска.БанковскийСчетКасса;
		КонецЕсли;
	КонецЦикла;
	
	ДополнительныеСвойства.Вставить("ТаблицаОбъектовОплаты", ТаблицаОбъектовОплаты);
	
КонецПроцедуры

Функция ОбъектыОплатыПоНаборуЗаписей()

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	НаборЗаписей.ВидДвижения КАК ВидДвижения,
		|	НаборЗаписей.Регистратор КАК Регистратор,
		|	НаборЗаписей.Организация КАК Организация,
		|	НаборЗаписей.ВидПереводаДенежныхСредств КАК ВидПереводаДенежныхСредств,
		|	НаборЗаписей.Получатель КАК Получатель,
		|	НаборЗаписей.Отправитель КАК Отправитель,
		|	НаборЗаписей.Контрагент КАК Контрагент,
		|	НаборЗаписей.Договор КАК Договор,
		|	НаборЗаписей.Валюта КАК Валюта,
		|	НаборЗаписей.Сумма КАК Сумма
		|ПОМЕСТИТЬ ТаблицаЗаписей
		|ИЗ
		|	&НаборЗаписей КАК НаборЗаписей
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ЕСТЬNULL(Приход.ВидПереводаДенежныхСредств, Расход.ВидПереводаДенежныхСредств) КАК ВидПереводаДенежныхСредств,
		|	ЕСТЬNULL(Приход.Получатель, Расход.Получатель) КАК Получатель,
		|	ЕСТЬNULL(Приход.Отправитель, Расход.Отправитель) КАК Отправитель,
		|	ЕСТЬNULL(Приход.Контрагент, Расход.Контрагент) КАК Контрагент,
		|	ЕСТЬNULL(Приход.Сумма, 0) - ЕСТЬNULL(Расход.Сумма, 0) КАК Сумма
		|ИЗ
		|	(ВЫБРАТЬ
		|		ТаблицаЗаписей.Регистратор КАК Регистратор,
		|		ТаблицаЗаписей.Организация КАК Организация,
		|		ТаблицаЗаписей.ВидПереводаДенежныхСредств КАК ВидПереводаДенежныхСредств,
		|		ТаблицаЗаписей.Получатель КАК Получатель,
		|		ТаблицаЗаписей.Отправитель КАК Отправитель,
		|		ТаблицаЗаписей.Контрагент КАК Контрагент,
		|		ТаблицаЗаписей.Договор КАК Договор,
		|		ТаблицаЗаписей.Валюта КАК Валюта,
		|		СУММА(ТаблицаЗаписей.Сумма) КАК Сумма
		|	ИЗ
		|		ТаблицаЗаписей КАК ТаблицаЗаписей
		|	ГДЕ
		|		ТаблицаЗаписей.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
		|	
		|	СГРУППИРОВАТЬ ПО
		|		ТаблицаЗаписей.Регистратор,
		|		ТаблицаЗаписей.Организация,
		|		ТаблицаЗаписей.ВидПереводаДенежныхСредств,
		|		ТаблицаЗаписей.Получатель,
		|		ТаблицаЗаписей.Отправитель,
		|		ТаблицаЗаписей.Контрагент,
		|		ТаблицаЗаписей.Договор,
		|		ТаблицаЗаписей.Валюта) КАК Приход
		|		ПОЛНОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
		|			ТаблицаЗаписей.Регистратор КАК Регистратор,
		|			ТаблицаЗаписей.Организация КАК Организация,
		|			ТаблицаЗаписей.ВидПереводаДенежныхСредств КАК ВидПереводаДенежныхСредств,
		|			ТаблицаЗаписей.Получатель КАК Получатель,
		|			ТаблицаЗаписей.Отправитель КАК Отправитель,
		|			ТаблицаЗаписей.Контрагент КАК Контрагент,
		|			ТаблицаЗаписей.Договор КАК Договор,
		|			ТаблицаЗаписей.Валюта КАК Валюта,
		|			СУММА(ТаблицаЗаписей.Сумма) КАК Сумма
		|		ИЗ
		|			ТаблицаЗаписей КАК ТаблицаЗаписей
		|		ГДЕ
		|			ТаблицаЗаписей.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)
		|		
		|		СГРУППИРОВАТЬ ПО
		|			ТаблицаЗаписей.Регистратор,
		|			ТаблицаЗаписей.Организация,
		|			ТаблицаЗаписей.ВидПереводаДенежныхСредств,
		|			ТаблицаЗаписей.Получатель,
		|			ТаблицаЗаписей.Отправитель,
		|			ТаблицаЗаписей.Контрагент,
		|			ТаблицаЗаписей.Договор,
		|			ТаблицаЗаписей.Валюта) КАК Расход
		|		ПО Приход.Регистратор = Расход.Регистратор
		|			И Приход.Организация = Расход.Организация
		|			И Приход.ВидПереводаДенежныхСредств = Расход.ВидПереводаДенежныхСредств
		|			И Приход.Получатель = Расход.Получатель
		|			И Приход.Отправитель = Расход.Отправитель
		|			И Приход.Контрагент = Расход.Контрагент
		|			И Приход.Договор = Расход.Договор
		|			И Приход.Валюта = Расход.Валюта
		|ГДЕ
		|	ЕСТЬNULL(Приход.Сумма, 0) - ЕСТЬNULL(Расход.Сумма, 0) <> 0
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|УНИЧТОЖИТЬ ТаблицаЗаписей";
	
	Запрос.УстановитьПараметр("НаборЗаписей", Выгрузить());
	
	Возврат Запрос.Выполнить().Выгрузить();

КонецФункции

#КонецОбласти

#КонецЕсли