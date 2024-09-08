﻿#Область СлужебныеПроцедурыИФункции

#Область ИспользуютРаспознанныйДокумент

Функция СоздатьДокументыКомплектаВызовСервера(ПараметрыСоздания) Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("УдалосьПровести", Ложь);
	Результат.Вставить("СоответствиеСтатусОбработан", Неопределено);
	Результат.Вставить("ОшибкиПроведения", Новый Соответствие);
	
	ТипыДокументов = РаспознаваниеДокументовКомплектыКлиентСервер.СоздаваемыеДокументыКомплекта(ПараметрыСоздания);
	
	РаспознанныеОбъектыДляТипа = Новый Массив;
	ОткудаПрикреплятьСканы = Новый Массив;
	ТаблицаРаспознанныхСозданных = Новый ТаблицаЗначений;
	ТаблицаРаспознанныхСозданных.Колонки.Добавить("РаспознанныйОбъект");
	ТаблицаРаспознанныхСозданных.Колонки.Добавить("СоздаваемыйДокумент");
	ТаблицаРаспознанныхСозданных.Колонки.Добавить("СоздатьДокумент");
	ТаблицаРаспознанныхСозданных.Колонки.Добавить("ДанныеОбратнойСвязи");
	
	Если ПараметрыСоздания.Свойство("ДанныеОбработки") И ПараметрыСоздания.ДанныеОбработки.Свойство("СозданоДокументов") Тогда
		НуженПодсчет = Истина;
		СозданоДокументов = ПараметрыСоздания.ДанныеОбработки.СозданоДокументов;
		ПрикрепленоСканов = ПараметрыСоздания.ДанныеОбработки.ПрикрепленоСканов;
	Иначе
		НуженПодсчет = Ложь;
	КонецЕсли;

	СоздаваемыйДокумент = Неопределено;
	УдалосьПровести = Ложь;
	ОбщийТекстОшибки = НСтр("ru = 'Исправьте ошибки заполнения документов комплекта или обработайте их по отдельности.'");
	НачатьТранзакцию();
	Попытка
		Для Каждого ЭтотТипДокумента Из ТипыДокументов Цикл
			ДанныеСозданного = ПараметрыСоздания.СозданныеДокументы[ЭтотТипДокумента];
			ТипыРаспознанных = РаспознаваниеДокументовКомплектыКлиентСервер.ПодходящиеТипыРаспознанногоДокумента(ЭтотТипДокумента);
			
			РаспознанныеОбъектыДляТипа.Очистить();
			ОткудаПрикреплятьСканы.Очистить();
			ДанныеРаспознанного = Неопределено;
			УстановленСтатусОбработан = Ложь;
			Для Каждого ТипРаспознанного Из ТипыРаспознанных Цикл
				ДопДанныеРаспознанного = ПараметрыСоздания.РаспознанныеДокументыПоТипам.Получить(ТипРаспознанного);
				Если ДопДанныеРаспознанного = Неопределено Тогда
					Продолжить;
				КонецЕсли;
				
				ДопРаспознанныйОбъект = ДопДанныеРаспознанного.Ссылка.ПолучитьОбъект();
				Если (ДанныеСозданного.СоздатьДокумент Или ДанныеСозданного.ДокументНайден)
					И Не (УстановленСтатусОбработан И ДопРаспознанныйОбъект.ТипДокумента 
					= Перечисления.ТипыДокументовРаспознаваниеДокументов.СчетФактура) Тогда
					
					// Статус Обработан ставится всем распознанным документам, которые будут созданы или для них найден типовой документ,
					// но есть исключение: возможно создание поступления/реализации по СФ (см. ПодходящиеТипыРаспознанногоДокумента), но ей
					// не нужно ставить Статус Обработан, если фактически поступление/реализация создается по Торг12, Акту или УПД
					ДопРаспознанныйОбъект.Статус = Перечисления.СтатусыСозданныхДокументовРаспознаваниеДокументов.Обработан;
					ДопРаспознанныйОбъект.Записать();
					УстановленСтатусОбработан = Истина;
				КонецЕсли;
				
				РаспознанныеОбъектыДляТипа.Добавить(ДопРаспознанныйОбъект);
				
				Если ДанныеРаспознанного = Неопределено Тогда
					ДанныеРаспознанного = ДопДанныеРаспознанного;
					РаспознанныйОбъект = ДопРаспознанныйОбъект;
					Если ДанныеСозданного.ПрикрепитьСкан Тогда
						// Для прикрепления основного скана
						ОткудаПрикреплятьСканы.Добавить(ДопРаспознанныйОбъект);
					КонецЕсли;
				ИначеЕсли СоздаваемыйДокумент = Неопределено
					И ДанныеСозданного.СоздатьДокумент // Эти данные потребуются, только если нужно СоздатьДокумент
					И РаспознаваниеДокументовКомплектыКлиентСервер.НужноОбъединитьТабличныеЧасти(РаспознанныйОбъект.ТипДокумента, ДопРаспознанныйОбъект.ТипДокумента) Тогда
					
					// Дополняем ДанныеРаспознанного только, если основного документа не было
					Для Каждого ЭтотПараметр Из ДопДанныеРаспознанного.ПараметрыЗаполнения Цикл
						Если ТипЗнч(ЭтотПараметр.Значение) = Тип("Массив") Тогда
							Для Каждого СтрокаТаблицы Из ЭтотПараметр.Значение Цикл
								ДанныеРаспознанного.ПараметрыЗаполнения[ЭтотПараметр.Ключ].Добавить(СтрокаТаблицы);
							КонецЦикла;
						КонецЕсли;
					КонецЦикла;
					
				КонецЕсли;
				
				Если ДанныеСозданного.ПрикрепитьСкан
					И НужноПрикрепитьДополнительныйСкан(ПараметрыСоздания.ТипКомплекта, ТипРаспознанного, ЭтотТипДокумента) Тогда
					ОткудаПрикреплятьСканы.Добавить(ДопРаспознанныйОбъект);
				КонецЕсли;
				
			КонецЦикла;
			
			Если Не ДанныеСозданного.СоздатьДокумент Тогда
				СоздаваемыйДокумент = ДанныеСозданного.Ссылка;
			Иначе
				
				ОбрабатываемыйДокумент = ДанныеРаспознанного.Ссылка;
				Если СоздаваемыйДокумент = Неопределено Тогда
					
					// Создание основного документа
					ТипДокументаСтрокой = СтрРазделить(XMLТип(ЭтотТипДокумента).ИмяТипа, ".")[1];
					
					СоздаваемыйДокумент = РаспознаваниеДокументовСлужебный.СоздатьДокументНаОснованииРаспознанного(
						ДанныеРаспознанного.Ссылка,
						ТипДокументаСтрокой,
						ДанныеРаспознанного.ПараметрыЗаполнения,
						РежимЗаписиДокумента.Проведение
					);
					
					СоздаваемыйДокументОбъект = СоздаваемыйДокумент.ПолучитьОбъект();
					
					Если ЭтотТипДокумента = Тип("ДокументСсылка.ПриобретениеТоваровУслуг")
						Или ЭтотТипДокумента = Тип("ДокументСсылка.РеализацияТоваровУслуг") Тогда
						
						Если Не ЗначениеЗаполнено(СоздаваемыйДокументОбъект.ДоговорКонтрагента) Тогда
							СоздаваемыйДокументОбъект.ДоговорКонтрагента = РаспознаваниеДокументовСлужебный.НайтиДоговорКонтрагента(РаспознанныйОбъект);
						КонецЕсли;
						СоздаваемыйДокументОбъект.Склад = РаспознаваниеДокументовСлужебныйКлиентСервер.ЗначениеРеквизитаДокумента(РаспознанныйОбъект, "Склад");
						Если Не ЗначениеЗаполнено(СоздаваемыйДокументОбъект.Склад) Тогда
							СоздаваемыйДокументОбъект.Склад = РаспознаваниеДокументовПереопределяемый.ПолучитьСкладПоУмолчанию();
						КонецЕсли;
					КонецЕсли;
					
					СоздаваемыйДокументОбъект.Записать(РежимЗаписиДокумента.Проведение);
					Если НуженПодсчет Тогда
						СозданоДокументов = СозданоДокументов + 1;
					КонецЕсли;
					
					ДанныеСозданного.Ссылка = СоздаваемыйДокумент;
					
				Иначе
					
					// Создание подчиненного документа
					Если ЭтотТипДокумента = Тип("ДокументСсылка.ПриобретениеТоваровУслуг")
						Или ЭтотТипДокумента = Тип("ДокументСсылка.РеализацияТоваровУслуг") Тогда
						
						// Постепление или Реализацию создаем на основании счета на оплату из СоздаваемыйДокументОбъект
						ТипДокументаСтрокой = СтрРазделить(XMLТип(ЭтотТипДокумента).ИмяТипа, ".")[1];
						ПараметрыЗаполнения = СоздаваемыйДокумент;
						
						СоздаваемыйДокументОбъект = Документы[ТипДокументаСтрокой].СоздатьДокумент();
						СоздаваемыйДокументОбъект.Заполнить(ПараметрыЗаполнения);
						
						СоздаваемыйДокументОбъект.Номер = РаспознанныйОбъект.НомерДокумента;
						Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(СоздаваемыйДокументОбъект, "НомерВходящегоДокумента") Тогда
							СоздаваемыйДокументОбъект.НомерВходящегоДокумента = РаспознанныйОбъект.НомерДокумента;
						КонецЕсли;
						СоздаваемыйДокументОбъект.Дата = РаспознанныйОбъект.ДатаДокумента;
						Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(СоздаваемыйДокументОбъект, "ДатаВходящегоДокумента") Тогда
							СоздаваемыйДокументОбъект.ДатаВходящегоДокумента = РаспознанныйОбъект.ДатаДокумента;
						КонецЕсли;
						
						Если Не ЗначениеЗаполнено(СоздаваемыйДокументОбъект.ДоговорКонтрагента) Тогда
							СоздаваемыйДокументОбъект.ДоговорКонтрагента = РаспознаваниеДокументовСлужебный.НайтиДоговорКонтрагента(РаспознанныйОбъект);
						КонецЕсли;
						СоздаваемыйДокументОбъект.Склад = РаспознаваниеДокументовСлужебныйКлиентСервер.ЗначениеРеквизитаДокумента(РаспознанныйОбъект, "Склад");
						Если Не ЗначениеЗаполнено(СоздаваемыйДокументОбъект.Склад) Тогда
							СоздаваемыйДокументОбъект.Склад = РаспознаваниеДокументовПереопределяемый.ПолучитьСкладПоУмолчанию();
						КонецЕсли;
						
						Если РаспознанныйОбъект.ТипДокумента = Перечисления.ТипыДокументовРаспознаваниеДокументов.УПД Тогда
							СоздаваемыйДокументОбъект.ЭтоУниверсальныйДокумент = Истина;
							// Признак ЭтоУПД будем ставить только если данные для Поступления (или Реализации) брались именно из УПД.
							// Также по приоритетам это будет значит, что в комплект не входят Торг-12 или Акт, иначе данные брались бы оттуда.
						КонецЕсли;
						
						СоздаваемыйДокументОбъект.Записать(РежимЗаписиДокумента.Проведение);
						Если НуженПодсчет Тогда
							СозданоДокументов = СозданоДокументов + 1;
						КонецЕсли;
						СоздаваемыйДокумент = СоздаваемыйДокументОбъект.Ссылка;
						
						ДанныеСозданного.Ссылка = СоздаваемыйДокумент;
						
					ИначеЕсли ЭтотТипДокумента = Тип("ДокументСсылка.СчетФактураПолученный")
						Или ЭтотТипДокумента = Тип("ДокументСсылка.СчетФактураВыданный") Тогда
						
						СчетФактураСсылка = Неопределено;
						ТипДокументаСтрокой = СтрРазделить(XMLТип(ЭтотТипДокумента).ИмяТипа, ".")[1];
						
						ПараметрыЗаполнения = ДанныеРаспознанного.ПараметрыЗаполнения;
						ПараметрыЗаполнения.Вставить("НомерВходящегоДокумента", РаспознанныйОбъект.НомерДокумента);
						ПараметрыЗаполнения.Вставить("ДатаВходящегоДокумента", РаспознанныйОбъект.ДатаДокумента);
						
						ПараметрыСозданияСФ = Новый Структура;
						ПараметрыСозданияСФ.Вставить("ТипДокументаСтрокой", ТипДокументаСтрокой);
						ПараметрыСозданияСФ.Вставить("Основание", СоздаваемыйДокумент);
						ПараметрыСозданияСФ.Вставить("ПараметрыЗаполнения", ПараметрыЗаполнения);
						
						РаспознаваниеДокументовПереопределяемый.ПриСозданииСчетФактуры(ПараметрыСозданияСФ, СчетФактураСсылка);
						
						Если СчетФактураСсылка = Неопределено Тогда
							ВызватьИсключение ОбщийТекстОшибки;
						Иначе
							СоздаваемыйДокумент = СчетФактураСсылка;
						КонецЕсли;
						
						Если НуженПодсчет Тогда
							СозданоДокументов = СозданоДокументов + 1;
						КонецЕсли;
						
						ДанныеСозданного.Ссылка = СоздаваемыйДокумент;
						
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
			
			ОбрабатываемыйДокумент = СоздаваемыйДокумент;
			Если ДанныеСозданного.ПрикрепитьСкан Тогда
				Для Каждого ОбъектСоСканом Из ОткудаПрикреплятьСканы Цикл
					АдресКартинки = ПоместитьВоВременноеХранилище(ОбъектСоСканом.ИсходноеИзображение.Получить());
					РаспознаваниеДокументовСлужебный.ДобавитьПрисоединенныйФайл(ОбъектСоСканом, СоздаваемыйДокумент, АдресКартинки);
					Если НуженПодсчет Тогда
						ПрикрепленоСканов = ПрикрепленоСканов + 1;
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;
			
			Для Каждого ЭтотРаспознанныйОбъект Из РаспознанныеОбъектыДляТипа Цикл
				СтрокаТаблицыСвязи = ТаблицаРаспознанныхСозданных.Добавить();
				СтрокаТаблицыСвязи.РаспознанныйОбъект = ЭтотРаспознанныйОбъект;
				СтрокаТаблицыСвязи.СоздаваемыйДокумент = СоздаваемыйДокумент;
				СтрокаТаблицыСвязи.СоздатьДокумент = ДанныеСозданного.СоздатьДокумент;
			КонецЦикла;
			
		КонецЦикла;
		
		УдалосьПровести = Истина;
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		
		СообщенияОбОшибках = Новый Массив(ПолучитьСообщенияПользователю(Истина));
		ПредставлениеОшибки = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
		
		Если ПредставлениеОшибки <> ОбщийТекстОшибки Тогда
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
			СообщенияОбОшибках.Вставить(0, Сообщение);
		КонецЕсли;
		Результат.ОшибкиПроведения.Вставить(ОбрабатываемыйДокумент, СообщенияОбОшибках);
		
		Возврат Результат;
	КонецПопытки;
	
	Если НуженПодсчет Тогда
		ПараметрыСоздания.ДанныеОбработки.СозданоДокументов = СозданоДокументов;
		ПараметрыСоздания.ДанныеОбработки.ПрикрепленоСканов = ПрикрепленоСканов;
	КонецЕсли;
	
	ТипыДокументовВСервисе = РаспознаваниеДокументовСлужебныйКлиентСервер.ПолучитьОбратноеСоответствие(Документы.РаспознанныйДокумент.СоответствиеТиповДокументовВСервисеИБРД());
	set_id = Строка(Новый УникальныйИдентификатор);
	
	ОсновнойДокумент = Истина;
	Для Каждого СтрокаТаблицыСвязи Из ТаблицаРаспознанныхСозданных Цикл
		ДанныеОбратнойСвязи = РаспознаваниеДокументовКомплектыВызовСервера.ПолучитьОбратнуюСвязьДляСозданногоДокумента(
			СтрокаТаблицыСвязи.РаспознанныйОбъект,
			СтрокаТаблицыСвязи.СоздаваемыйДокумент
		);
		Если СтрокаТаблицыСвязи.СоздатьДокумент Тогда
			Пакет = Новый Структура;
			Пакет.Вставить("created", ДанныеОбратнойСвязи);
			РаспознаваниеДокументовКоннекторСлужебный.ПередатьОбратнуюСвязь(СтрокаТаблицыСвязи.РаспознанныйОбъект.ИдентификаторРезультата, Пакет);
		КонецЕсли;
		
		// Пакет created отправлен. Готовим из данные для set_creation
		ДанныеОбратнойСвязи.Удалить("Статус");
		ДанныеОбратнойСвязи.Вставить("set_id", set_id);
		ДанныеОбратнойСвязи.Вставить("doc_uuid", СтрокаТаблицыСвязи.РаспознанныйОбъект.ИдентификаторРезультата);
		ДанныеОбратнойСвязи.Вставить("ТипДокумента", ТипыДокументовВСервисе.Получить(СтрокаТаблицыСвязи.РаспознанныйОбъект.ТипДокумента));
		ДанныеОбратнойСвязи.Вставить("ОсновнойДокумент", ОсновнойДокумент);
		Если ОсновнойДокумент Тогда
			ОсновнойДокумент = Ложь;
		КонецЕсли;
		
		СтрокаТаблицыСвязи.ДанныеОбратнойСвязи = ДанныеОбратнойСвязи;
	КонецЦикла;
	
	
	ДанныеПакета = Новый Массив;
	Если ПараметрыСоздания.ДанныеОбработки <> Неопределено
		И ПараметрыСоздания.Свойство("НомерКомплекта") Тогда
		
		ДанныеКомплекта = ПараметрыСоздания.ДанныеОбработки.РезультатОбратнойСвязи.Комплекты.Получить(ПараметрыСоздания.НомерКомплекта);
		Для Каждого КлючЗначение Из ДанныеКомплекта Цикл
			СвязьНайдена = Ложь;
			Для Каждого СтрокаТаблицыСвязи Из ТаблицаРаспознанныхСозданных Цикл
				Если СтрокаТаблицыСвязи.РаспознанныйОбъект.Ссылка = КлючЗначение.Ключ Тогда
					СтрокаТаблицыСвязи.ДанныеОбратнойСвязи.Вставить("Действие", КлючЗначение.Значение);
					ДанныеПакета.Добавить(СтрокаТаблицыСвязи.ДанныеОбратнойСвязи);
					
					СвязьНайдена = Истина;
					Прервать;
				КонецЕсли;
			КонецЦикла;
			
			Если Не СвязьНайдена Тогда
				// При каких условиях можно зайти в эту ветку?
				
				ДопРаспознанныеДанные = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(КлючЗначение.Ключ,
					"Номер, Направление, ТипДокумента, НомерДокумента, ДатаДокумента, СуммаДокумента, Контрагент, Организация, ИдентификаторРезультата");
				ДопДанныеПакета = РаспознаваниеДокументовКомплектыВызовСервера.ПолучитьОбратнуюСвязьДляСозданногоДокумента(ТаблицаРаспознанныхСозданных[0].РаспознанныйОбъект);
				ДопДанныеПакета.Удалить("Статус");
				ДопДанныеПакета.Вставить("set_id", set_id);
				ДопДанныеПакета.Вставить("doc_uuid", ДопРаспознанныеДанные.ИдентификаторРезультата);
				ДопДанныеПакета.Вставить("ТипДокумента", ТипыДокументовВСервисе.Получить(ДопРаспознанныеДанные.ТипДокумента));
				ДопДанныеПакета.Вставить("ОсновнойДокумент", Ложь);
				ДопДанныеПакета.Вставить("Действие", КлючЗначение.Значение);
				
				ДанныеПакета.Добавить(ДопДанныеПакета);
			КонецЕсли;
		КонецЦикла;
		
		Если ПараметрыСоздания.ДанныеОбработки.ГрупповаяОбработка Тогда
			ОбратнаяСвязь = ПараметрыСоздания.ДанныеОбработки.РезультатОбратнойСвязи.Отправить;
			Если Не ЗначениеЗаполнено(ОбратнаяСвязь) Тогда
				ОбратнаяСвязь.Вставить("ИдентификаторРезультата", ТаблицаРаспознанныхСозданных[0].РаспознанныйОбъект.ИдентификаторРезультата);
				ОбратнаяСвязь.Вставить("ДанныеПакета", ДанныеПакета);
			Иначе
				Для Каждого ЧастьПакета Из ДанныеПакета Цикл
					ОбратнаяСвязь.ДанныеПакета.Добавить(ЧастьПакета);
				КонецЦикла;
			КонецЕсли;
		Иначе
			Пакет = Новый Структура;
			Пакет.Вставить("set_creation", Новый Структура("set_data", ДанныеПакета));
			РаспознаваниеДокументовКоннекторСлужебный.ПередатьОбратнуюСвязь(ТаблицаРаспознанныхСозданных[0].РаспознанныйОбъект.ИдентификаторРезультата, Пакет);
		КонецЕсли;
	Иначе
		Для Каждого СтрокаТаблицыСвязи Из ТаблицаРаспознанныхСозданных Цикл
			СтрокаТаблицыСвязи.ДанныеОбратнойСвязи.Вставить("Действие", "ДобавленАвтоматически");
			ДанныеПакета.Добавить(СтрокаТаблицыСвязи.ДанныеОбратнойСвязи);
		КонецЦикла;
		
		Пакет = Новый Структура;
		Пакет.Вставить("set_creation", Новый Структура("set_data", ДанныеПакета));
		РаспознаваниеДокументовКоннекторСлужебный.ПередатьОбратнуюСвязь(ТаблицаРаспознанныхСозданных[0].РаспознанныйОбъект.ИдентификаторРезультата, Пакет);
	КонецЕсли;
	
	Результат.УдалосьПровести = УдалосьПровести;
	
	СоответствиеСтатусОбработан = Новый Соответствие;
	Для Каждого СтрокаТаблицыСвязи Из ТаблицаРаспознанныхСозданных Цикл
		СоответствиеСтатусОбработан.Вставить(СтрокаТаблицыСвязи.РаспознанныйОбъект.Ссылка, СтрокаТаблицыСвязи.СоздаваемыйДокумент);
	КонецЦикла;
	Результат.СоответствиеСтатусОбработан = СоответствиеСтатусОбработан;
	
	Если Результат.УдалосьПровести
		И ПараметрыСоздания.ДанныеОбработки <> Неопределено
		И ПараметрыСоздания.Свойство("НомерКомплекта") Тогда
		
		ПараметрыСоздания.ДанныеОбработки.НомераСозданныхКомплектов.Добавить(ПараметрыСоздания.НомерКомплекта);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция НужноПрикрепитьДополнительныйСкан(ТипКомплекта, ТипРаспознанного, ТипСозданного) Экспорт
	
	// Кроме основного скана могут потребоваться дополнительные
	Если ТипКомплекта = "АктОбОказанииУслугСчетНаОплатуТОРГ12"
		Или ТипКомплекта = "АктОбОказанииУслугСчетФактураТОРГ12"
		Или ТипКомплекта = "АктОбОказанииУслугСчетНаОплатуСчетФактураТОРГ12"
		Тогда
		
		Если ТипРаспознанного = Перечисления.ТипыДокументовРаспознаваниеДокументов.АктОбОказанииУслуг
			И (ТипСозданного = Тип("ДокументСсылка.ПриобретениеТоваровУслуг")
				Или ТипСозданного = Тип("ДокументСсылка.РеализацияТоваровУслуг")) Тогда
				
			Возврат Истина;
		КонецЕсли;
	КонецЕсли;
	
	Если ТипКомплекта = "АктОбОказанииУслугСчетФактураУПД"
		Или ТипКомплекта = "СчетФактураТОРГ12УПД"
		Или ТипКомплекта = "АктОбОказанииУслугСчетНаОплатуСчетФактураУПД"
		Или ТипКомплекта = "СчетНаОплатуСчетФактураТОРГ12УПД"
		Тогда
		
		Если ТипРаспознанного = Перечисления.ТипыДокументовРаспознаваниеДокументов.УПД
			И (ТипСозданного = Тип("ДокументСсылка.ПриобретениеТоваровУслуг")
				Или ТипСозданного = Тип("ДокументСсылка.РеализацияТоваровУслуг")) Тогда
				
			Возврат Истина;
		КонецЕсли;
	КонецЕсли;
	
	Если ТипКомплекта = "АктОбОказанииУслугТОРГ12УПД"
		Или ТипКомплекта = "АктОбОказанииУслугСчетФактураТОРГ12УПД"
		Или ТипКомплекта = "АктОбОказанииУслугСчетНаОплатуТОРГ12УПД"
		Или ТипКомплекта = "АктОбОказанииУслугСчетНаОплатуСчетФактураТОРГ12УПД"
		Тогда
		
		Если (ТипРаспознанного = Перечисления.ТипыДокументовРаспознаваниеДокументов.УПД
				Или ТипРаспознанного = Перечисления.ТипыДокументовРаспознаваниеДокументов.АктОбОказанииУслуг)
			И (ТипСозданного = Тип("ДокументСсылка.ПриобретениеТоваровУслуг")
				Или ТипСозданного = Тип("ДокументСсылка.РеализацияТоваровУслуг")) Тогда
				
			Возврат Истина;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

Функция ПараметрыЗаполненияДляСозданияДокумента(РаспознанныйДокумент, ТипРаспознанного, ТипСоздаваемого, ПараметрыОперации) Экспорт
	
	Результат = Неопределено;
	
	ТипДокументаСтрокой = СтрРазделить(XMLТип(ТипСоздаваемого).ИмяТипа, ".")[1];
	Если ТипРаспознанного = ПредопределенноеЗначение("Перечисление.ТипыДокументовРаспознаваниеДокументов.ТОРГ12")
		Или ТипРаспознанного = ПредопределенноеЗначение("Перечисление.ТипыДокументовРаспознаваниеДокументов.АктОбОказанииУслуг")
		Или ТипРаспознанного = ПредопределенноеЗначение("Перечисление.ТипыДокументовРаспознаваниеДокументов.УПД")
		Или ТипРаспознанного = ПредопределенноеЗначение("Перечисление.ТипыДокументовРаспознаваниеДокументов.СчетФактура") Тогда
		
		Результат = РаспознаваниеДокументовСлужебныйВызовСервера.ПараметрыЗаполненияТиповойНаОсновеФормыТОРГ12(
			РаспознанныйДокумент,
			ПараметрыОперации.ВидОперации,
			ТипДокументаСтрокой
		);
		
	ИначеЕсли ТипРаспознанного = ПредопределенноеЗначение("Перечисление.ТипыДокументовРаспознаваниеДокументов.СчетНаОплату") Тогда
		
		Результат = РаспознаваниеДокументовСлужебныйВызовСервера.ПараметрыЗаполненияТиповойНаОсновеСчетНаОплату(
			РаспознанныйДокумент,
			ТипДокументаСтрокой
		);
		
	КонецЕсли;
	
	Если Результат <> Неопределено Тогда
		Результат.Вставить("ТипДокументаСтрокой", ТипДокументаСтрокой);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ДанныеЯчейкиШапкиНаСервере(ПараметрыПолучения) Экспорт
	
	Если ПараметрыПолучения.ИмяРеквизита = "Контрагент" Или ПараметрыПолучения.ИмяРеквизита = "Организация" Тогда
		ИменаРеквизитов = РаспознаваниеДокументовСлужебныйКлиентСервер.ИменаРеквизитовКонтрагентИОрганизация(ПараметрыПолучения);
		Если ИменаРеквизитов.Свойство(ПараметрыПолучения.ИмяРеквизита) Тогда
			ИмяРеквизита = ИменаРеквизитов[ПараметрыПолучения.ИмяРеквизита];
		Иначе
			ИмяРеквизита = ПараметрыПолучения.ИмяРеквизита;
		КонецЕсли;
	ИначеЕсли ПараметрыПолучения.ИмяРеквизита = "БанковскийСчет" Тогда
		ИменаРеквизитов = ИмяРеквизитаБанковскийСчет(ПараметрыПолучения);
		Если ИменаРеквизитов.Свойство(ПараметрыПолучения.ИмяРеквизита) Тогда
			ИмяРеквизита = ИменаРеквизитов[ПараметрыПолучения.ИмяРеквизита];
		Иначе
			ИмяРеквизита = ПараметрыПолучения.ИмяРеквизита;
		КонецЕсли;
	Иначе
		ИмяРеквизита = ПараметрыПолучения.ИмяРеквизита;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", ПараметрыПолучения.Ссылка);
	Запрос.УстановитьПараметр("ИмяРеквизита", ИмяРеквизита);
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	РаспознанныйДокументРеквизитыДокумента.РаспознанныйТекст КАК РаспознанныйТекст,
	|	РаспознанныйДокументРеквизитыДокумента.ОбластьИзображения КАК ОбластьИзображения,
	|	РаспознанныйДокументРеквизитыДокумента.КоординатаX0 КАК КоординатаX0,
	|	РаспознанныйДокументРеквизитыДокумента.КоординатаY0 КАК КоординатаY0,
	|	РаспознанныйДокументРеквизитыДокумента.КоординатаX1 КАК КоординатаX1,
	|	РаспознанныйДокументРеквизитыДокумента.КоординатаY1 КАК КоординатаY1,
	|	РаспознанныйДокументРеквизитыДокумента.СтрокВИзображении КАК СтрокВИзображении
	|ИЗ
	|	Документ.РаспознанныйДокумент.РеквизитыДокумента КАК РаспознанныйДокументРеквизитыДокумента
	|ГДЕ
	|	РаспознанныйДокументРеквизитыДокумента.Ссылка = &Ссылка
	|	И РаспознанныйДокументРеквизитыДокумента.ИмяРеквизита = &ИмяРеквизита
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	СписокВыбораРеквизитовРаспознаваниеДокументов.Значение КАК Значение,
	|	СписокВыбораРеквизитовРаспознаваниеДокументов.ДополнительноеЗначение КАК ДополнительноеЗначение,
	|	СписокВыбораРеквизитовРаспознаваниеДокументов.Уверенность КАК Уверенность,
	|	СписокВыбораРеквизитовРаспознаваниеДокументов.НайденВТаблицеСоответствий КАК НайденВТаблицеСоответствий
	|ИЗ
	|	РегистрСведений.СписокВыбораРеквизитовРаспознаваниеДокументов КАК СписокВыбораРеквизитовРаспознаваниеДокументов
	|ГДЕ
	|	СписокВыбораРеквизитовРаспознаваниеДокументов.РаспознанныйДокумент = &Ссылка
	|	И СписокВыбораРеквизитовРаспознаваниеДокументов.ИмяРеквизита = &ИмяРеквизита
	|	И &ДополнительныйОтбор
	|
	|УПОРЯДОЧИТЬ ПО
	|	НайденВТаблицеСоответствий УБЫВ,
	|	Уверенность УБЫВ";
	
	Если ПараметрыПолучения.ИмяРеквизита = "БанковскийСчет" Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ДополнительныйОтбор",
			"ВЫРАЗИТЬ(СписокВыбораРеквизитовРаспознаваниеДокументов.Значение КАК Справочник.БанковскиеСчета).Владелец = &Владелец");
		Запрос.УстановитьПараметр("Владелец", ПараметрыПолучения.ИсточникПоляБанковскийСчетВладелец);
	ИначеЕсли ПараметрыПолучения.ИмяРеквизита = "Договор" Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ДополнительныйОтбор",
			"ВЫРАЗИТЬ(СписокВыбораРеквизитовРаспознаваниеДокументов.Значение КАК Справочник.ДоговорыКонтрагентов).Владелец = &Контрагент
			|	И ВЫРАЗИТЬ(СписокВыбораРеквизитовРаспознаваниеДокументов.Значение КАК Справочник.ДоговорыКонтрагентов).ВидДоговора В(&ВидыДоговора)
			|	И ВЫРАЗИТЬ(СписокВыбораРеквизитовРаспознаваниеДокументов.Значение КАК Справочник.ДоговорыКонтрагентов).Организация = &Организация");
		Запрос.УстановитьПараметр("Контрагент", ПараметрыПолучения.ИсточникПоляДоговорКонтрагент);
		Запрос.УстановитьПараметр("ВидыДоговора", ПараметрыПолучения.ИсточникПоляДоговорВидДоговора);
		Запрос.УстановитьПараметр("Организация", ПараметрыПолучения.ИсточникПоляДоговорОрганизация);
	Иначе
		Запрос.УстановитьПараметр("ДополнительныйОтбор", Истина);
	КонецЕсли;
	
	Результат = Новый Структура;
	Если ПараметрыПолучения.ОбновитьПолнуюКартинку Тогда
		Результат.Вставить("АдресПолнойКартинки", ПолучитьАдресПолнойКартинки(ПараметрыПолучения.Ссылка, ПараметрыПолучения.УникальныйИдентификатор));
	КонецЕсли;
	
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	Выборка = МассивРезультатов[0].Выбрать();
	Если Выборка.Следующий() Тогда
		КоординатыКартинки = Новый Массив(4);
		КоординатыКартинки[0] = Выборка.КоординатаX0;
		КоординатыКартинки[1] = Выборка.КоординатаY0;
		КоординатыКартинки[2] = Выборка.КоординатаX1;
		КоординатыКартинки[3] = Выборка.КоординатаY1;
		
		РаспознанныйТекст = Выборка.РаспознанныйТекст;
		СтрокВИзображении = Выборка.СтрокВИзображении;
		
		ДвоичныеДанные = Выборка.ОбластьИзображения.Получить();
		КартинкаВнутриHTML = КартинкаКакТекстHTML(ДвоичныеДанные);
		Результат.Вставить("КартинкаВнутриHTML", КартинкаВнутриHTML);
	Иначе
		КоординатыКартинки = Неопределено;
		РаспознанныйТекст = "";
		СтрокВИзображении = 0;
	КонецЕсли;
	
	ЗначенияВыбора = Новый Массив;
	Выборка = МассивРезультатов[1].Выбрать();
	Пока Выборка.Следующий() Цикл
		ВариантВыбора = Новый Структура("Значение, ДополнительноеЗначение, Уверенность, НайденВТаблицеСоответствий");
		ЗаполнитьЗначенияСвойств(ВариантВыбора, Выборка);
		ЗначенияВыбора.Добавить(ВариантВыбора);
	КонецЦикла;
	
	Результат.Вставить("РаспознанныйТекст", РаспознанныйТекст);
	Результат.Вставить("КоординатыКартинки", КоординатыКартинки);
	Результат.Вставить("СтрокВИзображении", СтрокВИзображении);
	Результат.Вставить("ЗначенияВыбора", ЗначенияВыбора);
	
	Возврат Результат;
	
КонецФункции

Функция ДанныеЯчейкиТаблицыНаСервере(ПараметрыПолучения) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", ПараметрыПолучения.Ссылка);
	Запрос.УстановитьПараметр("НомерСтрокиТЧ", ПараметрыПолучения.НомерСтрокиТЧ);
	Запрос.УстановитьПараметр("ИмяРеквизита", ПараметрыПолучения.ИмяРеквизита);
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	РаспознанныйДокументРеквизитыТабличныхЧастей.РаспознанныйТекст КАК РаспознанныйТекст,
	|	РаспознанныйДокументРеквизитыТабличныхЧастей.ОбластьИзображения КАК ОбластьИзображения,
	|	РаспознанныйДокументРеквизитыТабличныхЧастей.КоординатаX0 КАК КоординатаX0,
	|	РаспознанныйДокументРеквизитыТабличныхЧастей.КоординатаY0 КАК КоординатаY0,
	|	РаспознанныйДокументРеквизитыТабличныхЧастей.КоординатаX1 КАК КоординатаX1,
	|	РаспознанныйДокументРеквизитыТабличныхЧастей.КоординатаY1 КАК КоординатаY1,
	|	РаспознанныйДокументРеквизитыТабличныхЧастей.СтрокВИзображении КАК СтрокВИзображении
	|ИЗ
	|	Документ.РаспознанныйДокумент.РеквизитыТабличныхЧастей КАК РаспознанныйДокументРеквизитыТабличныхЧастей
	|ГДЕ
	|	РаспознанныйДокументРеквизитыТабличныхЧастей.Ссылка = &Ссылка
	|	И РаспознанныйДокументРеквизитыТабличныхЧастей.НомерСтрокиТЧ = &НомерСтрокиТЧ
	|	И РаспознанныйДокументРеквизитыТабличныхЧастей.ИмяРеквизита = &ИмяРеквизита
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	СписокВыбораТабличныхЧастейРаспознаваниеДокументов.Значение КАК Значение,
	|	СписокВыбораТабличныхЧастейРаспознаваниеДокументов.ДополнительноеЗначение КАК ДополнительноеЗначение,
	|	СписокВыбораТабличныхЧастейРаспознаваниеДокументов.Уверенность КАК Уверенность,
	|	СписокВыбораТабличныхЧастейРаспознаваниеДокументов.НайденВТаблицеСоответствий КАК НайденВТаблицеСоответствий
	|ИЗ
	|	РегистрСведений.СписокВыбораТабличныхЧастейРаспознаваниеДокументов КАК СписокВыбораТабличныхЧастейРаспознаваниеДокументов
	|ГДЕ
	|	СписокВыбораТабличныхЧастейРаспознаваниеДокументов.РаспознанныйДокумент = &Ссылка
	|	И СписокВыбораТабличныхЧастейРаспознаваниеДокументов.НомерСтрокиТЧ = &НомерСтрокиТЧ
	|	И СписокВыбораТабличныхЧастейРаспознаваниеДокументов.ИмяРеквизита = &ИмяРеквизита
	|
	|УПОРЯДОЧИТЬ ПО
	|	НайденВТаблицеСоответствий УБЫВ,
	|	Уверенность УБЫВ";
	
	Результат = Новый Структура;
	Если ПараметрыПолучения.ОбновитьПолнуюКартинку Тогда
		Результат.Вставить("АдресПолнойКартинки", ПолучитьАдресПолнойКартинки(ПараметрыПолучения.Ссылка, ПараметрыПолучения.УникальныйИдентификатор));
	КонецЕсли;
	
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	Выборка = МассивРезультатов[0].Выбрать();
	Если Выборка.Следующий() Тогда
		КоординатыКартинки = Новый Массив(4);
		КоординатыКартинки[0] = Выборка.КоординатаX0;
		КоординатыКартинки[1] = Выборка.КоординатаY0;
		КоординатыКартинки[2] = Выборка.КоординатаX1;
		КоординатыКартинки[3] = Выборка.КоординатаY1;
		
		РаспознанныйТекст = Выборка.РаспознанныйТекст;
		СтрокВИзображении = Выборка.СтрокВИзображении;
		
		ДвоичныеДанные = Выборка.ОбластьИзображения.Получить();
		КартинкаВнутриHTML = КартинкаКакТекстHTML(ДвоичныеДанные);
		Результат.Вставить("КартинкаВнутриHTML", КартинкаВнутриHTML);
	Иначе
		КоординатыКартинки = Неопределено;
		РаспознанныйТекст = "";
		СтрокВИзображении = 0;
	КонецЕсли;
	
	ЗначенияВыбора = Новый Массив;
	Выборка = МассивРезультатов[1].Выбрать();
	Пока Выборка.Следующий() Цикл
		ВариантВыбора = Новый Структура("Значение, ДополнительноеЗначение, Уверенность, НайденВТаблицеСоответствий");
		ЗаполнитьЗначенияСвойств(ВариантВыбора, Выборка);
		ЗначенияВыбора.Добавить(ВариантВыбора);
	КонецЦикла;
	
	Результат.Вставить("РаспознанныйТекст", РаспознанныйТекст);
	Результат.Вставить("КоординатыКартинки", КоординатыКартинки);
	Результат.Вставить("СтрокВИзображении", СтрокВИзображении);
	Результат.Вставить("ЗначенияВыбора", ЗначенияВыбора);
	
	Возврат Результат;
	
КонецФункции

Функция ИмяРеквизитаБанковскийСчет(ДанныеДокумента)
	
	// Ключ - БанковскийСчет
	// Значение - имя реквизита в документе
	Результат = Новый Структура;
	
	Если ДанныеДокумента.Направление = ПредопределенноеЗначение("Перечисление.НаправленияРаспознанногоДокумента.Входящий") Тогда
		Результат.Вставить("БанковскийСчет", "БанковскийСчетКонтрагента");
	Иначе
		Результат.Вставить("БанковскийСчет", "БанковскийСчетОрганизации");
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ПолучитьАдресПолнойКартинки(Ссылка, ИдентификаторФормы)
	
	ИсходноеИзображение = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "ИсходноеИзображение");
	Если ЗначениеЗаполнено(ИсходноеИзображение) Тогда
		АдресПолнойКартинки = ПоместитьВоВременноеХранилище(ИсходноеИзображение.Получить(), ИдентификаторФормы);
	Иначе
		АдресПолнойКартинки = ПоместитьВоВременноеХранилище(Неопределено, ИдентификаторФормы);
	КонецЕсли;
	
	Возврат АдресПолнойКартинки;
	
КонецФункции

Функция КартинкаКакТекстHTML(ДвоичныеДанные, Позиция = "Сбоку")
	
	Если ЗначениеЗаполнено(ДвоичныеДанные) Тогда
		DataImage = Base64Строка(ДвоичныеДанные);
		DataImage = СтрЗаменить(DataImage, Символы.ВК, "");
		DataImage = СтрЗаменить(DataImage, Символы.ПС, "");
	Иначе
		DataImage = "";
	КонецЕсли;
	DataImage = "data:image/jpg;base64," + DataImage;
	
	ШаблонHTML = 
		"<html>
		|<head>
		|  <style type=""text/css"">
		|    html, body { width: 100%; height:100%; margin: 0; padding: 0; }
		|    body {
		|      background-image: url('{{ DataImage }}');
		|      background-size: contain;
		|      background-repeat: no-repeat;
		|      background-position: left {{ Position }};
		|      scrollbar-width: none;
		|    }
		|    ::-webkit-scrollbar { display: none; }
		|  </style>
		|</head>
		|<body>
		|</body>
		|<html>";
	
	Результат = СтрЗаменить(ШаблонHTML, "{{ DataImage }}", DataImage);
	Результат = СтрЗаменить(Результат, "{{ Position }}", ?(Позиция = "Сбоку", "center", "bottom"));
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

Функция ЗапрещеноСозданиеДокументаВЗакрытомПериоде(Знач ТипДокументаСтрокой, Знач ДатаДокумента) Экспорт
	
	ПроверяемыйДокумент = Документы[ТипДокументаСтрокой].СоздатьДокумент();
	ПроверяемыйДокумент.Дата = ДатаДокумента;
	Если ТипДокументаСтрокой = "ЗаказКлиента" Или ТипДокументаСтрокой = "ЗаказПоставщику" Тогда
		РедактированиеЗапрещено = Ложь;
	Иначе
		РедактированиеЗапрещено = ДатыЗапретаИзменения.ИзменениеЗапрещено(ПроверяемыйДокумент);  
	КонецЕсли;
	
	Возврат РедактированиеЗапрещено;
	
КонецФункции

Функция ПолучитьОбратнуюСвязьДляСозданногоДокумента(ДокументОбъект, СоздаваемыйДокумент = Неопределено) Экспорт
	
	Результат = РаспознаваниеДокументов.ОписаниеОбратнойСвязи("Проведен");
	Если СоздаваемыйДокумент = Неопределено Тогда
		Результат.IdСозданногоДокумента = "";
	Иначе
		Результат.IdСозданногоДокумента = Строка(СоздаваемыйДокумент.УникальныйИдентификатор());
	КонецЕсли;
	Результат.НомерРаспознанногоДокумента = ДокументОбъект.Номер;
	Результат.ЭтоВходящийДокумент = (ДокументОбъект.Направление = Перечисления.НаправленияРаспознанногоДокумента.Входящий);
	Результат.НомерДокумента = ДокументОбъект.НомерДокумента;
	Результат.ДатаДокумента = ДокументОбъект.ДатаДокумента;
	Результат.СуммаДокумента = ДокументОбъект.СуммаДокумента;
	Результат.Контрагент = РаспознаваниеДокументов.УбратьОрганизационнуюФорму(ДокументОбъект.Контрагент);
	Результат.Организация = РаспознаваниеДокументов.УбратьОрганизационнуюФорму(ДокументОбъект.Организация);
	Результат.ТипРаспознанногоДокумента = Строка(ДокументОбъект.ТипДокумента);
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти