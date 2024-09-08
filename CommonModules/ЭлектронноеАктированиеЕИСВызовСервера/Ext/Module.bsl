﻿#Область ПрограммныйИнтерфейс

// см. ЭлектронноеАктированиеЕИС.ОбменПоОрганизацииВключен
Функция ОбменПоОрганизацииВключен(Организация) Экспорт
	
	Возврат ЭлектронноеАктированиеЕИС.ОбменПоОрганизацииВключен(Организация);
	
КонецФункции

// Для документа заполняется результат судебного решения.
// Судебное решение заполняется для УПД и исправлений.
// 
// Параметры:
//  Документ - ДокументСсылка - ссылка на документ.
// 
// Возвращаемое значение:
//  Булево - Истина, если для документа заполняется результат судебного решения.
Функция ДляДокументаОтображаетсяСудебноеРешение(Документ) Экспорт
	
	Результат = Ложь;
	ЭлектронноеАктированиеЕИСПереопределяемый.
		ДляДокументаЗаполняетсяСудебноеРешение(Документ, Результат);
		
	Возврат Результат;
	
КонецФункции

// Представление контракта по договору.
// 
// Параметры:
//  Договор - ОпределяемыйТип.ДоговорСКонтрагентомЭДО
// 
// Возвращаемое значение:
//  Строка - Представление контракта по договору
Функция ПредставлениеКонтрактаПоДоговору(Договор) Экспорт
	
	Госконтракт = Договор.ГосударственныйКонтракт;
	
	Если ЗначениеЗаполнено(Госконтракт) Тогда
		Шаблон = НСтр("ru = 'Данные для электронного актирования по контракту №%1 от %2'");
		Представление = СтрШаблон(Шаблон, Госконтракт.Номер,
			Формат(Госконтракт.ДатаЗаключенияКонтракта, "ДФ=dd.MM.yyyy;"));
		Возврат Представление;
	Иначе
		Возврат "<нет данных о контракте>";
	КонецЕсли;
	
КонецФункции

// Используется несколько организаций.
// 
// Возвращаемое значение:
//  Булево - Используется несколько организаций
Функция ИспользуетсяНесколькоОрганизаций() Экспорт
	
	Возврат ОбщегоНазначенияБЭД.ИспользуетсяНесколькоОрганизаций();
	
КонецФункции

// Скрыть элементы формы при использовании одной организации.
// 
// Параметры:
//  Форма - ФормаКлиентскогоПриложения
//  ИмяЭлементаИлиМассив - Строка, Массив - Имя элемента или массив
Процедура СкрытьЭлементыФормыПриИспользованииОднойОрганизации(Форма, ИмяЭлементаИлиМассив) Экспорт
		
	Если НЕ ИспользуетсяНесколькоОрганизаций() Тогда
		
		Если ТипЗнч(ИмяЭлементаИлиМассив) = Тип("Массив") Тогда
			
			Для Каждого ИмяОдногоЭлемента Из ИмяЭлементаИлиМассив Цикл
				
				СкрываемыйЭлемент = Форма.Элементы.Найти(ИмяОдногоЭлемента);
				
				Если СкрываемыйЭлемент <> Неопределено Тогда
					СкрываемыйЭлемент.Видимость = Ложь;
				КонецЕсли;
				
			КонецЦикла; 
			
		ИначеЕсли ТипЗнч(ИмяЭлементаИлиМассив) = Тип("Строка") Тогда
			
			СкрываемыйЭлемент = Форма.Элементы.Найти(ИмяЭлементаИлиМассив);
			
			Если СкрываемыйЭлемент <> Неопределено Тогда
				
				СкрываемыйЭлемент.Видимость = Ложь;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Данные государственного контракта.
// 
// Параметры:
//  СсылкаНаКонтракт Ссылка на контракт
//  ВВидеСтроки - Булево - В виде строки
// 
// Возвращаемое значение:
//  Строка, Структура, Неопределено - см. ЭлектронноеАктированиеЕИС.НовыеДанныеКонтракта()
Функция ДанныеГосударственногоКонтракта(СсылкаНаКонтракт, ВВидеСтроки=Ложь) Экспорт
	
	Возврат ЭлектронноеАктированиеЕИС.ДанныеГосударственногоКонтракта(СсылкаНаКонтракт, ВВидеСтроки);
	
КонецФункции

// Данные строк контракта по номенклатуре.
// 
// Параметры:
//  ГосударственныйКонтрактЕИС - СправочникСсылка.ГосударственныеКонтрактыЕИС
//  Номенклатура - ОпределяемыйТип.НоменклатураБЭД
// 
// Возвращаемое значение:
//  Массив - Данные строк контракта по номенклатуре
Функция ДанныеСтрокКонтрактаПоНоменклатуре(ГосударственныйКонтрактЕИС, Номенклатура) Экспорт
	
	Запрос = Новый Запрос;
	ТекстЗапроса = "ВЫБРАТЬ
	               |	ГосударственныеКонтрактыЕИСНоменклатураОбъектовЗакупки.Идентификатор КАК Идентификатор,
	               |	ГосударственныеКонтрактыЕИСНоменклатураОбъектовЗакупки.Номенклатура КАК Номенклатура,
	               |	ГосударственныеКонтрактыЕИСНоменклатураОбъектовЗакупки.Количество КАК Количество,
	               |	ГосударственныеКонтрактыЕИСОбъектыЗакупки.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	               |	ГосударственныеКонтрактыЕИСОбъектыЗакупки.Количество КАК Количество1,
	               |	ГосударственныеКонтрактыЕИСОбъектыЗакупки.Цена КАК Цена,
	               |	ГосударственныеКонтрактыЕИСОбъектыЗакупки.Сумма КАК Сумма,
	               |	ГосударственныеКонтрактыЕИСОбъектыЗакупки.КодТовараДляЕИС КАК КодТовараДляЕИС,
	               |	ГосударственныеКонтрактыЕИСОбъектыЗакупки.СтавкаНДС КАК СтавкаНДС,
	               |	ГосударственныеКонтрактыЕИСОбъектыЗакупки.Тип КАК Тип
	               |ИЗ
	               |	Справочник.ГосударственныеКонтрактыЕИС.НоменклатураОбъектовЗакупки КАК ГосударственныеКонтрактыЕИСНоменклатураОбъектовЗакупки
	               |		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ГосударственныеКонтрактыЕИС.ОбъектыЗакупки КАК ГосударственныеКонтрактыЕИСОбъектыЗакупки
	               |		ПО ГосударственныеКонтрактыЕИСНоменклатураОбъектовЗакупки.Идентификатор = ГосударственныеКонтрактыЕИСОбъектыЗакупки.Идентификатор
	               |ГДЕ
	               |	ГосударственныеКонтрактыЕИСНоменклатураОбъектовЗакупки.Ссылка = &ГосКонтрактСсылка
	               |	И ГосударственныеКонтрактыЕИСНоменклатураОбъектовЗакупки.Номенклатура = &Номенклатура";
	
	Запрос.УстановитьПараметр("ГосКонтрактСсылка", ГосударственныйКонтрактЕИС);
	Запрос.УстановитьПараметр("Номенклатура", Номенклатура);

	ТекстЗапроса = ЗаменитьИмяСправочникаГосКонтрактов(ТекстЗапроса);
	Запрос.Текст = ТекстЗапроса;
	
	ИдентификаторыСтрокКонтракта = Запрос.Выполнить().Выгрузить();
	Возврат ОбщегоНазначения.ТаблицаЗначенийВМассив(ИдентификаторыСтрокКонтракта);
	
КонецФункции

// Обработка выбора государственного контракта.
// 
// Параметры:
//  Владелец - ОпределяемыйТип.ДоговорСКонтрагентомЭДО
//  ПредыдущееЗначение - СправочникСсылка.ГосударственныеКонтрактыЕИС
//  НовоеЗначение - СправочникСсылка.ГосударственныеКонтрактыЕИС
Процедура ОбработкаВыбораГосударственногоКонтракта(Владелец,
		ПредыдущееЗначение,
		НовоеЗначение) Экспорт
	
	Если ПредыдущееЗначение = НовоеЗначение Тогда
		// Не изменилось значение.
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ПредыдущееЗначение) И НЕ ПредыдущееЗначение.Пустая() Тогда
		// Очищаем договор-владелец предыдущего контракта.
		ОбъектКонтракта = ПредыдущееЗначение.ПолучитьОбъект();
		ОбъектКонтракта.ВладелецКонтракта = Неопределено;
		ОбъектКонтракта.Записать();
	КонецЕсли;
	
	Если ЗначениеЗаполнено(НовоеЗначение) И НЕ НовоеЗначение.Пустая() Тогда
		// Заполняем договор-владелец нового контракта.
		ОбъектКонтракта = НовоеЗначение.ПолучитьОбъект();
		ОбъектКонтракта.ВладелецКонтракта = Владелец.Ссылка;
		ОбъектКонтракта.Записать();
	КонецЕсли;
	
КонецПроцедуры

// Найти государственный контракт по владельцу.
// 
// Параметры:
//  ВладелецКонтракта - ОпределяемыйТип.ДоговорСКонтрагентомЭДО
// 
// Возвращаемое значение:
//  СправочникСсылка.ГосударственныеКонтрактыЕИС, Произвольный - Найти государственный контракт по владельцу
Функция НайтиГосударственныйКонтрактПоВладельцу(ВладелецКонтракта) Экспорт
	
	Возврат ЭлектронноеАктированиеЕИС.НайтиГосударственныйКонтрактПоВладельцу(ВладелецКонтракта);
	
КонецФункции

// Подписанты ЕИС.
// 
// Параметры:
//  Объект - ОпределяемыйТип.ОснованияЭлектронныхДокументовЭДО
// 
// Возвращаемое значение:
//  Массив - Подписанты ЕИС
Функция ПодписантыЕИС(Объект) Экспорт
	
	Возврат ЭлектронноеАктированиеЕИС.ПодписантыЕИС(Объект);
	
КонецФункции

// Приложенные документы для ЕИС.
// 
// Параметры:
//  Объект - ОпределяемыйТип.ОснованияЭлектронныхДокументовЭДО
// 
// Возвращаемое значение:
//  Массив - Приложенные документы для ЕИС
Функция ПриложенныеДокументыДляЕИС(Объект) Экспорт
	
	ТаблицаФайлов = ЭлектронноеАктированиеЕИС.ДанныеФайловПрисоединенныхКДокументу(Объект);
	
	Возврат ОбщегоНазначения.ТаблицаЗначенийВМассив(ТаблицаФайлов);
	
КонецФункции

// Места поставки для ЕИС.
// 
// Параметры:
//  Объект - ОпределяемыйТип.ОснованияЭлектронныхДокументовЭДО
// 
// Возвращаемое значение:
//  Массив - Места поставки для ЕИС
Функция МестаПоставкиДляЕИС(Объект) Экспорт
	
	Возврат ЭлектронноеАктированиеЕИС.МестаПоставкиДляЕИС(Объект);
	
КонецФункции

// При изменении идентификатора для актирования ЕИС.
// 
// Параметры:
//  СписокВыбора - СписокЗначений - список выбора.
//  ТабЧасть - Строка - имя табличной части.
//  СтрокаТаблицы - СтрокаТаблицыЗначений - строка таблицы.
Процедура ПриИзмененииИдентификатораДляАктированияЕИС(СписокВыбора, ТабЧасть, СтрокаТаблицы) Экспорт
	
	ИдентификаторДляАктированияЕИС = СтрокаТаблицы.ПредставлениеДляАктированияЕИС;
	СтрокаТаблицы.ИдентификаторДляАктированияЕИС = ИдентификаторДляАктированияЕИС;
	Элемент = СписокВыбора.НайтиПоЗначению(ИдентификаторДляАктированияЕИС);
	Если Элемент = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Представление = Элемент.Представление;
	СтрокаТаблицы.ПредставлениеДляАктированияЕИС = Представление;
	
КонецПроцедуры

// Данные строки контракта по идентификатору.
// 
// Параметры:
//  Договор - СправочникСсылка - ссылка на договор.
//  ИдентификаторСтрокиКонтракта - Строка - идентификатор строки контракта.
// 
// Возвращаемое значение:
//  Произвольный - Данные строки контракта по идентификатору
Функция ДанныеСтрокиКонтрактаПоИдентификатору(Договор, ИдентификаторСтрокиКонтракта) Экспорт
	
	Данные = ЭлектронноеАктированиеЕИС.
		ДанныеДляЗаполненияТабличнойЧастиДокумента(Договор, ИдентификаторСтрокиКонтракта);
	ДанныеСтрокКонтракта = ОбщегоНазначения.ТаблицаЗначенийВМассив(Данные);
	
	Возврат ДанныеСтрокКонтракта[0];
	
КонецФункции

// Возвращает государственный контракт договора. Если договор не назначен,
// то возвращается пустая ссылка.
// 
// Параметры:
//  Договор - ОпределяемыйТип.ДоговорСКонтрагентомЭДО - Договор
// 
// Возвращаемое значение:
//  ОпределяемыйТип.ГосударственныеКонтрактыБЭД - ссылка на государственный контракт договора.
Функция ГосударственныйКонтрактДоговора(Договор) Экспорт
	
	Возврат ЭлектронноеАктированиеЕИС.ГосударственныйКонтрактДоговора(Договор);
	
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Для документа заполняются места поставки.
// 
// Параметры:
//  Документ - ДокументСсылка - ссылка на документ.
// 
// Возвращаемое значение:
//  Булево - Истина, если для документа заполняются места поставки.
Функция ДляДокументаЗаполняютсяМестаПоставки(Документ) Экспорт
	
	Результат = Ложь;
	ЭлектронноеАктированиеЕИСПереопределяемый.
		ДляДокументаЗаполняютсяМестаПоставки(Документ, Результат);
		
	Возврат Результат;
	
КонецФункции

// Места поставки документа.
// 
// Параметры:
//  Документ - ДокументСсылка - ссылка на документ.
// 
// Возвращаемое значение:
//  Массив - места поставки документа.
Функция МестаПоставкиДокумента(Документ) Экспорт
	
	МестаПоставки = Новый Массив;
	ЭлектронноеАктированиеЕИСПереопределяемый.
		ЗаполнитьМестаПоставкиДокумента(Документ, МестаПоставки);
		
	Возврат МестаПоставки;
	
КонецФункции

// см. ЭлектронноеАктированиеЕИСПереопределяемый.ДоговорКонтрагентаИсточникаКоманды 
Функция ДоговорКонтрагентаИсточникаКоманды(ИсточникКоманды) Экспорт
	
	ДоговорКонтрагента = Неопределено;
	ЭлектронноеАктированиеЕИСПереопределяемый.
		ДоговорКонтрагентаИсточникаКоманды(ИсточникКоманды, ДоговорКонтрагента);
	Возврат ДоговорКонтрагента;
	
КонецФункции

// Есть подключенные к ЛК ЕИС организации.
// 
// Возвращаемое значение:
//  Булево - Есть подключенные организации
Функция ЕстьПодключенныеОрганизации() Экспорт
	
	Результат = Ложь;
	Если ЭлектронноеАктированиеЕИС.ИспользоватьЭлектронноеАктированиеВЕИС() Тогда
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1
		               |	НастройкиОбменаЕИС.Организация КАК Организация
		               |ИЗ
		               |	РегистрСведений.НастройкиОбменаЕИС КАК НастройкиОбменаЕИС
		               |ГДЕ
		               |	НастройкиОбменаЕИС.ОбменВключен = ИСТИНА";
		УстановитьПривилегированныйРежим(Истина);
		Выборка = Запрос.Выполнить().Выбрать();
		УстановитьПривилегированныйРежим(Ложь);
		Результат = Выборка.Следующий();
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Есть подсистема актирования для заказчиков.
// 
// Возвращаемое значение:
//  Булево - Истина, если в конфигурации присутствует подсистема для заказчиков.
Функция ЕстьПодсистемаДляЗаказчиков() Экспорт
	
	Возврат ЭлектронноеАктированиеЕИС.ЕстьПодсистемаДляЗаказчиков();
	
КонецФункции

// См. ЭлектронноеАктированиеЕИС.ЗаменитьИмяСправочникаГосКонтрактов
Функция ЗаменитьИмяСправочникаГосКонтрактов(СтрокаДляЗамены) Экспорт
	
	Возврат ЭлектронноеАктированиеЕИС.ЗаменитьИмяСправочникаГосКонтрактов(СтрокаДляЗамены);
	
КонецФункции

#КонецОбласти